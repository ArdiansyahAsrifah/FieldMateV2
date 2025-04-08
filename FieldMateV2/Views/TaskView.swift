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
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                    
                    Text(task.description)
                        .font(.caption)
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                }
                Spacer()
                
                Image(systemName: "chevron.right")
//                    .foregroundColor(.appContainer)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .font(.system(size: 20))
            }
            .padding()
//            .background(task.color)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "#7AD0E7"), Color(hex: "#55ABFA")]),
                        startPoint: .leading,
                        endPoint: .trailing
                )
            )
            .cornerRadius(10)
        }
    }
}

#Preview {
    TaskView(task: CalendarTask.sampleTasks[0])
}
