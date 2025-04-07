//
//  AppIntent.swift
//  FieldMateLiveActivity
//
//  Created by Muhammad Ardiansyah Asrifah on 26/03/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct FieldMateLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FieldMateLiveActivityAttributes.self) { context in
            print("📢 Live Activity UI Dibuat dengan Task: \(context.state.taskTitle) pada \(context.state.taskTime)")
            
            return VStack(alignment: .center) {
                
                Text("\(context.state.taskTitle)   |   ⏰ \(context.state.taskTime)")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.black)

                Text(context.state.taskLocation)
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundColor(.gray)
            }
            .padding()
        } dynamicIsland: { context in
            DynamicIsland(
                expanded: {
                    DynamicIslandExpandedRegion(.leading) {
                        VStack(alignment: .leading){
                            Text("7 April 2025")
                                .font(.system(size: 18, weight: .bold, design: .default))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                            Text("\(context.state.taskListTimes.count) Tugas Hari Ini")
                                .font(.system(size: 15, weight: .regular, design: .default))
                                .foregroundColor(.white)
                                .minimumScaleFactor(0.7)
                        }
                    }
                    DynamicIslandExpandedRegion(.trailing) {
                        VStack(alignment: .trailing){
                            Text(context.state.taskTitle)
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.white)
                            Text(context.state.taskLocation)
                                .font(.caption)
                                .foregroundColor(.orange)
                                .lineLimit(1)
                            Text("⏰ \(context.state.taskTime) ")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.white.opacity(0.8))
//                                .padding(.horizontal)
                        }
                    }
                    DynamicIslandExpandedRegion(.bottom) {
                        TaskProgressBar(taskTimes: context.state.taskListTimes)
                    }
                },
                compactLeading: {
                    Text(context.state.taskTitle)
                        .font(.caption2)
                        .foregroundColor(.white)
                },
                compactTrailing: {
                    Text(context.state.taskTime)
                        .font(.caption2)
                        .foregroundColor(.white)
                },
                minimal: {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.white)
                }
            )
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
                        .fill(Color.white)
                        .frame(width: 10, height: 10)
                    if index < taskTimes.count - 1 {
                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .overlay(
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 2)
                    .padding(.horizontal, 5),
                alignment: .center
            )
            
            HStack {
                ForEach(taskTimes, id: \.self) { time in
                    Text(time)
                        .font(.caption2)
                        .foregroundColor(.white)
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



@main
struct FieldMateLiveBundle: WidgetBundle {
    var body: some Widget {
        FieldMateLiveActivity()
    }
}

