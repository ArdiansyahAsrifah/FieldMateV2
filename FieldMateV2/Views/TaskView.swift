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
                        .foregroundColor(.white)
                    
                    Text(task.description)
                        .font(.caption)

                        .foregroundColor(.white)
                }
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
            }
            .padding()
            .background(
                Group {
                    if colorScheme == .dark {
                        AnimatedBackground()
                    } else {
                        AnimatedBackground()
                    }
                    
                    HStack {
                        Spacer()
                        Image(task.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                            .opacity(0.15)
                            .padding(.trailing, 10)
                    }
                }
            )
            .cornerRadius(10)
        }
        .toolbarBackground(.hidden)
    }
}

#Preview {
    TaskView(task: CalendarTask.sampleTasks[0])
}
