//
//  TaskView.swift
//  FieldMateV2
//
//  Created by Aretha Natalova Wahyudi on 05/04/25.
//

import SwiftUI

struct TaskView: View {
    let task: CalendarTask
    
    var body: some View {
        NavigationLink(destination: TaskDetailView(task: task)) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(task.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.appTextPrimary)
                    
                    Text(task.description)
                        .font(.caption)
                        .foregroundColor(.appTextSecondary)
                }
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.appContainer)
                    .font(.system(size: 20))
            }
            .padding()
            .background(task.color)
            .cornerRadius(10)
        }
    }
}
