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
            HStack (alignment: .top) {
                LiveActivityHeaderView(contentState: contentState)
                Spacer()
                NextTaskView(contentState: contentState)
            }
            TaskProgressBar(taskTimes: contentState.taskListTimes)
        }
        .padding()
        .padding(.bottom, 10)
    }
}

struct LiveActivityHeaderView: View {
    let contentState: FieldMateLiveActivityAttributes.ContentState
    var body: some View {
        VStack(alignment: .leading){
            Text("7 April 2025")
                .font(.system(size: 18, weight: .bold, design: .default))
//                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text("\(contentState.taskListTimes.count) Tugas Hari Ini")
                .font(.system(size: 15, weight: .regular, design: .default))
//                .foregroundColor(.white)
                .minimumScaleFactor(0.7)
        }
    }
}

struct NextTaskView: View {
    let contentState: FieldMateLiveActivityAttributes.ContentState
    
    var body: some View {
        VStack(alignment: .trailing){
            Text(contentState.taskTitle)
                .font(.subheadline)
                .bold()
//                .foregroundColor(.white)
            Text(contentState.taskLocation)
                .font(.caption)
                .foregroundColor(.orange)
                .lineLimit(1)
            Text("⏰ \(contentState.taskTime) ")
                .font(.caption)
                .bold()
//                .foregroundColor(.white.opacity(0.8))
        }
    }
}

struct TaskProgressBar: View {
    let taskTimes: [String]
    let startHour = 8
    let endHour = 17
    
    @State private var currentTimeFraction: CGFloat = 0.0
    
    let timer = Timer.publish(every:60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                let totalWidth = geometry.size.width
                
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(height: 8)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(4)
                        .position(x: totalWidth/2, y: 20)
                    
                    ForEach(taskTimes, id: \.self) { time in
                        if let fraction = timeFraction(for: time) {
                            Circle()
                                .fill(fraction > currentTimeFraction ? Color.blue : Color.gray)
                                .frame(width: 15, height: 15)
                                .position(x: totalWidth * fraction, y: 20)
                            if fraction > currentTimeFraction {
                                Text(time)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .position(x: totalWidth * fraction, y: 48)
                            }
                        }
                    }
                    
                    Text("⚙️")
                        .font(.system(size:35, weight:.regular, design:.default))
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
        .frame(maxWidth: .infinity, maxHeight: 60)
        .padding(.horizontal, 25)
        .padding(.bottom, 30)
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
