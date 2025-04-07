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
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                ForEach(0..<taskTimes.count, id: \.self) { index in
                    Circle()
//                        .fill(Color.white)
                        .frame(width: 10, height: 10)
                    if index < taskTimes.count - 1 {
                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .overlay(
                Rectangle()
//                    .fill(Color.white)
                    .frame(height: 2)
                    .padding(.horizontal, 5),
                alignment: .center
            )
            
            HStack {
                ForEach(taskTimes, id: \.self) { time in
                    Text(time)
                        .font(.caption2)
//                        .foregroundColor(.white)
                    if time != taskTimes.last {
                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: 40)
    }
}
