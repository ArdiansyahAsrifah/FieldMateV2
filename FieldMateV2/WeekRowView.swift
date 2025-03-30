//
//  WeekRowView.swift
//  FieldMateV2
//
//  Created by Muhammad Ardiansyah Asrifah on 26/03/25.
//

import SwiftUI

struct WeekRowView: View {
    let baseDate: Date
    @Binding var selectedDate: Date
    
    private let calendar = Calendar.current
    private var datesForWeek: [Date] {
        (0..<7).compactMap { index in
            calendar.date(byAdding: .day, value: index, to: baseDate)
        }
    }
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(datesForWeek, id: \.timeIntervalSince1970) { date in
                DayView(
                    date: date,
                    isSelected: calendar.isDate(date, inSameDayAs: selectedDate)
                )
                .onTapGesture {
                    selectedDate = date
                }
            }
        }
    }
}
