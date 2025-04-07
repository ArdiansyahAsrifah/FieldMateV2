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
            LiveActivityContent(contentState: context.state)
                .activityBackgroundTint(Color.white.opacity(0.9))
        } dynamicIsland: { context in
            DynamicIsland(
                expanded: {
                    expandedContent(contentState: context.state)
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
            .contentMargins(.all, 25, for:.expanded)
        }
    }
    
    @DynamicIslandExpandedContentBuilder
    private func expandedContent(contentState: FieldMateLiveActivityAttributes.ContentState) -> DynamicIslandExpandedContent<some View> {
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

