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
            VStack(alignment: .leading) {
                Text("🔔 Reminder Task")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(context.state.taskTitle)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("⏰ \(context.state.taskTime)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
            .background(Color.blue)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("Task")
                        .font(.caption2)
                        .foregroundColor(.white)
                }
                DynamicIslandExpandedRegion(.center) {
                    Text(context.state.taskTitle)
                        .font(.headline)
                        .foregroundColor(.white)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.taskTime)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
    }
}

