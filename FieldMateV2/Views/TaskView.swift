//
//  TaskView.swift
//  FieldMateV2
//
//  Created by Aretha Natalova Wahyudi on 05/04/25.
//

import SwiftUI

struct TaskView: View {
    let task: CalendarTask
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationLink(destination: TaskDetailView(task: task)) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(task.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
//                        .foregroundColor(colorScheme == .dark ? .black : .white)
                        .foregroundColor(.white)
                    
                    Text(task.description)
                        .font(.caption)
//                        .foregroundColor(colorScheme == .dark ? .black : .white)
                        .foregroundColor(.white)
                }
                Spacer()
                
                Image(systemName: "chevron.right")
//                    .foregroundColor(.appContainer)
//                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .foregroundColor(.white)
                    .font(.system(size: 20))
            }
            .padding()
//            .background(task.color)
            .background(
                Group {
                    if colorScheme == .dark {
                        AnimatedBackground()
                    } else {
//                        LinearGradient(
//                            gradient: Gradient(colors: [Color(hex: "#7AD0E7"), Color(hex: "#55ABFA")]),
//                            startPoint: .leading,
//                            endPoint: .trailing
//                        )
                        AnimatedBackground()
                    }
                }
            )
            .cornerRadius(10)
        }
    }
}

#Preview {
    TaskView(task: CalendarTask.sampleTasks[0])
}
