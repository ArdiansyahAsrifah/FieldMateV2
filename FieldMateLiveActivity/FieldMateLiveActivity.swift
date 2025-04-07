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
//            print("📢 Live Activity UI Dibuat dengan Task: \(context.state.taskTitle) pada \(context.state.taskTime)")
//            
//            return VStack(alignment: .center) {
//                
//                Text("\(context.state.taskTitle)   |   ⏰ \(context.state.taskTime)")
//                    .font(.title2)
//                    .bold()
//                    .foregroundColor(.black)
//
//                Text(context.state.taskLocation)
//                    .font(.subheadline)
//                    .fontWeight(.regular)
//                    .foregroundColor(.gray)
//            }
//            .padding()
            LiveActivityContent(
                contentState: context.state
            )
        } dynamicIsland: { context in
            DynamicIsland {
                expandedContent(
                    contentState: context.state
                )
            } compactLeading: {
                Text(context.state.taskTitle)
                    .font(.caption2)
                    .foregroundColor(.white)
            } compactTrailing: {
                Text(context.state.taskTime)
                    .font(.caption2)
                    .foregroundColor(.white)
            } minimal: {
                Image(systemName: "clock.fill")
                    .foregroundColor(.white)
            }
        }
    }
    @DynamicIslandExpandedContentBuilder
    private func expandedContent(
        contentState: FieldMateLiveActivityAttributes.ContentState) -> DynamicIslandExpandedContent<some View>{
            DynamicIslandExpandedRegion(.leading) {
                LiveActivityHeaderView(contentState: contentState)
            }
            DynamicIslandExpandedRegion(.trailing) {
                NextTaskView(contentState: contentState)
            }
            DynamicIslandExpandedRegion(.bottom) {
                TaskProgressBar(taskTimes: contentState.taskListTimes)
            }
        }
}

@main
struct FieldMateLiveBundle: WidgetBundle {
    var body: some Widget {
        FieldMateLiveActivity()
    }
}

