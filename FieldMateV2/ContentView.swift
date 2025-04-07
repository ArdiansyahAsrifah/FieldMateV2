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
    @State private var isAnimating = false
    
    var body: some View {
            NavigationView {
                ZStack {
                    Color.appBackground.ignoresSafeArea()

                    VStack(spacing: 0) {
                        // Header(isShowingEventModal: $isShowingEventModal)
                        WeekView(selectedDate: $selectedDate)
                            .padding(.top, 20)
                        
                        Spacer()
                        
                        TaskListView(selectedDate: selectedDate)
                            .padding(.top, 8)
                            .padding(.bottom, -40)
                    }

                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
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

