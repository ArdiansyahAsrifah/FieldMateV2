//
//  Timeline.swift
//  FieldMateV2
//
//  Created by Muhammad Ardiansyah Asrifah on 26/03/25.
//

import SwiftUI

struct TimelineView: View {
    let hourSpacing: CGFloat
    
    var body: some View {
        VStack(alignment: .trailing, spacing: hourSpacing) {
            ForEach(0..<25) { hour in
                TimelineHourView(hour: hour)
            }
        }
        .padding(.bottom, 40)
    }
}

struct TimelineHourView: View {
    let hour: Int
    
    private var timeString: String {
        String(format: "%d:00", hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour))
    }
    
    private var amPm: String {
        hour < 12 ? "AM" : "PM"
    }
    
    var body: some View {
        VStack(alignment: .trailing) {
            Text(timeString)
            Text(amPm)
        }
        .font(.footnote)
        .fontWeight(.semibold)
        .foregroundColor(.appTextPrimary)
        .frame(height: 30)
        .id("hour-\(hour)")
    }
}

struct CurrentTimeIndicator: View {
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter.string(from: currentTime)
    }
    
    let hourSpacing: CGFloat
    private let timelineHourHeight: CGFloat = 30
    
    private var indicatorOffset: CGFloat {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: currentTime)
        let hour = CGFloat(components.hour ?? 0)
        let minute = CGFloat(components.minute ?? 0)
        
        return (hour + minute / 60) * (hourSpacing + timelineHourHeight)
    }
    
    var body: some View {
        HStack {
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color.appBackground)
                    .frame(width: 4)
                    .cornerRadius(2)
                
                Rectangle()
                    .fill(Color.appTeal)
                    .frame(width: 4, height: indicatorOffset + 10)
                    .cornerRadius(2)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.appTeal)
                        .frame(width: 35, height: 20)
                    
                    Text(timeString)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.appTextPrimary)
                }
                .offset(y: indicatorOffset)
            }
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
    }
}
