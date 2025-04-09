//
//  LiveActivityView.swift
//  FieldMateV2
//
//  Created by Aretha Natalova Wahyudi on 07/04/25.
//

import SwiftUI
import WidgetKit
import ActivityKit

struct LiveActivityContent: View {
    let contentState: FieldMateLiveActivityAttributes.ContentState
    
    var body: some View {
        VStack (alignment: .leading){
            HStack (alignment: .firstTextBaseline) {
                LiveActivityHeaderView()
                Spacer()
                NextTaskView(contentState: contentState)
            }
            TaskProgressBar(taskTimes: contentState.taskListTimes)
                .padding(.horizontal, 20)
        }
        .padding()
        .padding(.bottom, 5)
    }
}

struct LiveActivityHeaderView: View {
//    let contentState: FieldMateLiveActivityAttributes.ContentState
    var body: some View {
        VStack(alignment: .leading){
//            Text("Tugas Selanjutnya →")
//                .font(.system(size: 20, weight: .bold, design: .default))
//                .minimumScaleFactor(0.7)
//            Text("\(contentState.taskListTimes.count) Tugas Hari Ini")
//                .font(.system(size: 15, weight: .regular, design: .default))
//                .minimumScaleFactor(0.7)
            Text("Selanjutnya")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
        }
        .padding(3)
        .background(.gray)
        .cornerRadius(5)
    }
}

struct NextTaskView: View {
    let contentState: FieldMateLiveActivityAttributes.ContentState
    
    var body: some View {
        VStack(alignment: .trailing){
            Text(contentState.taskTitle)
                .font(.headline)
                .bold()
            Text(contentState.taskLocation)
                .font(.caption)
                .foregroundColor(.orange)
                .lineLimit(1)
        }
    }
}

struct TaskProgressBar: View {
    let taskTimes: [String]
    let startHour = 8
    let endHour = 17
    
    @State private var currentTimeFraction: CGFloat = 0.0
    let timer = Timer.publish(every:60, on: .main, in: .common).autoconnect()
    
    var showLabels: Bool {
            taskTimes.compactMap { timeFraction(for: $0) }
                     .contains { $0 > currentTimeFraction }
        }
    
    var body: some View {
        VStack(alignment: .center) {
            GeometryReader { geometry in
                let totalWidth = geometry.size.width
                
                VStack(alignment:.center){
                    ZStack() {
                        Rectangle()
                            .frame(height: 8)
                            .frame(width: totalWidth)
                            .cornerRadius(4)
                            .position(x: 140, y: 20)
    //                    HStack {
    //                        Rectangle()
    //                            .frame(height: 8)
    //                            .frame(maxWidth: totalWidth * currentTimeFraction)
    //                            .cornerRadius(4)
    //                            .position(x: 140, y: 20)
    //                            .opacity(0.2)
    //                        Rectangle()
    //                            .frame(height: 8)
    ////                            .frame(maxWidth: .infinity)
    //                            .cornerRadius(4)
    //                            .position(x: 140, y: 20)
    //                    }
    //                    .frame(width: .infinity)
                        
                        ForEach(taskTimes, id: \.self) { time in
                            if let fraction = timeFraction(for: time) {
    //                            Image(systemName: "arrowshape.right.circle.fill")
                                Text("⚙️")
                                    .font(.system(size:28, weight:.regular, design:.default))
    //                                .foregroundColor(fraction > currentTimeFraction ? .blue : .gray)
    //                                .frame(width: 20, height: 20)
                                    .opacity(fraction > currentTimeFraction ? 1 : 0.2)
                                    .position(x: totalWidth * fraction, y: 20)
                                if fraction > currentTimeFraction {
                                    Text(time)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .position(x: totalWidth * fraction, y: 48)
                                }
                            }
                        }
                        
    //                    Text("⚙️")
    //                        .font(.system(size:35, weight:.regular, design:.default))
    //                        .position(x: totalWidth * currentTimeFraction, y: 20)
    //                        .animation(.linear(duration: 0.5), value: currentTimeFraction)
                        Image(systemName: "play.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color(hex: "#2980D0"))
                            .frame(width: 20, height:20)
                            .position(x: totalWidth * currentTimeFraction, y: 20)
                            .animation(.linear(duration: 0.5), value: currentTimeFraction)
                    }
                    .onReceive(timer) { _ in
                        updateCurrentTimeFraction(totalWidth: totalWidth)
                    }
                    .onAppear {
                        updateCurrentTimeFraction(totalWidth: totalWidth)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .padding(.horizontal, 10)
        .padding(.bottom, showLabels ? 35 : 20)
    }
    func timeFraction(for time: String) -> CGFloat? {
        let components = time.split(separator: ":")
        guard components.count == 2,
              let hour = Double(components[0]),
              let minute = Double(components[1]) else { return nil }
        
        let totalMinutes = hour * 60 + minute
        let startMinutes = Double(startHour * 60)
        let endMinutes = Double(endHour * 60)
        
        let fraction = (totalMinutes - startMinutes) / (endMinutes - startMinutes)
        return CGFloat(min(max(fraction, 0), 1))
    }
    
    func updateCurrentTimeFraction(totalWidth: CGFloat) {
            let now = Date()
            let calendar = Calendar.current
            let hour = Double(calendar.component(.hour, from: now))
            let minute = Double(calendar.component(.minute, from: now))
            let totalNow = hour * 60 + minute
            
            let startMinutes = Double(startHour * 60)
            let endMinutes = Double(endHour * 60)
            
            let fraction = (totalNow - startMinutes) / (endMinutes - startMinutes)
            currentTimeFraction = CGFloat(min(max(fraction, 0), 1))
        }
}
