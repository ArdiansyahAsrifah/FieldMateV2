//
//  CalendarTask.swift
//  FieldMateV2
//
//  Created by Muhammad Ardiansyah Asrifah on 26/03/25.
//

import SwiftUI

struct CalendarTask: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let startTime: Date
    let duration: TimeInterval
    let color: Color
}

extension CalendarTask {
    static let sampleTasks: [CalendarTask] = {
        let calendar = Calendar.current
        let now = Date()
        
        func time(hour: Int, minute: Int = 0) -> Date {
            calendar.date(bySettingHour: hour, minute: minute, second: 0, of: now) ?? now
        }
        
        return [
            CalendarTask(
                title: "Cek AC",
                description: "Apple Developer Academy",
                startTime: time(hour: 9, minute: 30),
                duration: 3600,
                color: .appOrange
            ),
            
            CalendarTask(
                title: "Preventif Lift",
                description: "GOP 9 Ground Floor",
                startTime: time(hour: 11),
                duration: 1800,
                color: .appTeal
            ),
            
            CalendarTask(
                title: "Pintu Utama Rusak",
                description: "Purwadhika School",
                startTime: time(hour: 13),
                duration: 3600,
                color: .appPurple
            ),
            
            CalendarTask(
                title: "Flush Toilet",
                description: "GOP 9 Ground Floor",
                startTime: time(hour: 15, minute: 30),
                duration: 1800,
                color: .appPink
            ),
            
            CalendarTask(
                title: "Penggantian Lampu",
                description: "Koridor GOP 9",
                startTime: time(hour: 17),
                duration: 3600,
                color: .appBlue
            )
        ]
    }()
}
