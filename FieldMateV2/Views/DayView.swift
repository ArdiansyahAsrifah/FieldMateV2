//
//  DayView.swift
//  FieldMateV2
//
//  Created by Muhammad Ardiansyah Asrifah on 26/03/25.
//

import SwiftUI

struct DayView: View {
    let date: Date
    let isSelected: Bool

    @Environment(\.colorScheme) var colorScheme // 🌓 Tambahkan ini

    private let calendar = Calendar.current

    private var weekdayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).uppercased()
    }

    private var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    private var isToday: Bool {
        calendar.isDateInToday(date)
    }

    private var isWeekend: Bool {
        let weekday = calendar.component(.weekday, from: date)
        return weekday == 1 || weekday == 7
    }

    private var textColor: Color {
        if isSelected {
            // Jika dark mode dan dipilih, font-nya hitam
            return colorScheme == .dark ? .black : .white
        }
        if isToday {
            return .white
        }
        return isWeekend ? .appTextSecondary : .appTextPrimary
    }

    private var borderColor: Color {
        if isSelected {
            return .appTeal
        }
        return isToday ? .appTeal : .appBorder
    }

    var body: some View {
        VStack(spacing: 8) {
            Text(weekdayString)
                .font(.caption)
                .fontWeight(isSelected ? .semibold : .regular)

            Text(dayString)
                .font(.title3)
                .fontWeight(isSelected ? .bold : .semibold)
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(textColor)
        .padding(.vertical, 8)
        .background(
            ZStack {
                if isSelected {
                    // 🟡 Kalau dipilih dan dark mode → putih
                    // Kalau dipilih dan light mode → hitam
                    (colorScheme == .dark ? Color.white : Color.black)
                } else {
                    Color.appContainer
                }

                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: isToday ? 2 : 1)
            }
        )
        .cornerRadius(10)
    }
}
