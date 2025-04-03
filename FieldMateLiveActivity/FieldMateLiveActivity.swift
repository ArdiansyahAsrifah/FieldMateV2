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
//                Text("⚙️")
//                    .font(.headline)
//                    .foregroundColor(.white)
                
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
                        Text("Tugas Hari Ini")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                    }
                    DynamicIslandExpandedRegion(.center) {
                        Text(context.state.taskTitle)
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                        Text(context.state.taskLocation)
                            .font(.caption)
                            .foregroundColor(.orange)
                        Text("⏰ \(context.state.taskTime) ")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal)

                    }
                    DynamicIslandExpandedRegion(.trailing) {
                        Text("Tugas Berikutnya: Flush Toilet 🚽")
                            .font(.caption)
                            .foregroundColor(.white)
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

@main
struct FieldMateLiveBundle: WidgetBundle {
    var body: some Widget {
        FieldMateLiveActivity()
    }
}

