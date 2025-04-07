//
//  TaskListView.swift
//  FieldMateV2
//
//  Created by Muhammad Ardiansyah Asrifah on 26/03/25.
//

import SwiftUI

struct TaskListView: View {
    let tasks = CalendarTask.sampleTasks
    let selectedDate: Date

    @State private var initialScrollPerformed = false
    @State private var timeSlotScale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0

    private let minScale: CGFloat = 0.5
    private let maxScale: CGFloat = 2.0
    private let defaultHourSpacing: CGFloat = 40

    private var hourSpacing: CGFloat {
        defaultHourSpacing * timeSlotScale
    }

    // Filter hanya jam yang memiliki task
    private var taskHours: [Int] {
        let calendar = Calendar.current
        let hours = tasks.map { calendar.component(.hour, from: $0.startTime) }
        return Array(Set(hours)).sorted()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text(dateFormatter.string(from: selectedDate))
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.appTextPrimary)

                Text("Kamu Punya \(tasks.count) Tugas Hari Ini! 🧑‍🔧")
                    .font(.callout)
                    .foregroundColor(.appTextSecondary)
            }
            GeometryReader { geometry in
                ScrollViewReader { scrollProxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(taskHours, id: \.self) { hour in
                                HStack {
                                    Text("\(hour):00")
                                        .frame(width: 46, alignment: .trailing)
                                        .font(.headline)
                                        .foregroundColor(.gray)

                                    VStack(spacing: 8) {
                                        ForEach(tasks.filter { Calendar.current.component(.hour, from: $0.startTime) == hour }) { task in
                                            TaskView(task: task)
                                        }
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
//                        .frame(minHeight: geometry.size.height)
                        .padding(.vertical, 22)
                    }
                    .onAppear {
                        if !initialScrollPerformed, let firstTaskHour = taskHours.first {
                            scrollProxy.scrollTo(firstTaskHour, anchor: .top)
                            initialScrollPerformed = true
                        }
                    }
                }
            }
        }
        .padding(25)
        .background(
            ZStack {
                Color.appContainer
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.appBorder, lineWidth: 1)
            }
        )
        .cornerRadius(20)
    }

    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "EEEE, d MMMM  yyyy"
        return formatter
    }()
}

#Preview {
    CalendarView()
}
