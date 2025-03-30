//
//  ContentView.swift
//  FieldMateV2
//
//  Created by Muhammad Ardiansyah Asrifah on 26/03/25.
//

import SwiftUI

struct CalendarView: View {
    @State private var isShowingEventModal = false
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                VStack(spacing: 16) {
                    Header(isShowingEventModal: $isShowingEventModal)
                    
                    WeekView(selectedDate: $selectedDate)
                        .padding(.bottom, 4)
                    
                    TaskListView(selectedDate: selectedDate)
                }
                .padding(.top)
            }
        }
    }
}

#Preview("Light Mode") {
    CalendarView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    CalendarView()
        .preferredColorScheme(.dark)
}

