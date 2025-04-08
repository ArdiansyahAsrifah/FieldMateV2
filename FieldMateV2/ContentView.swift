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
    @State private var showGreeting = true
    
    var body: some View {
            NavigationView {
                ZStack {
                    AnimatedBackground()

                    VStack(alignment: .leading, spacing: 0) {
                        // Header(isShowingEventModal: $isShowingEventModal)
//                        Spacer(minLength: 100)
//                        Text("Hai Engineer!")
//                            .bold()
//                            .font(.title)
//                            .padding(.leading, -150)
//                            .foregroundColor(Color.white)
                        
                        if showGreeting {
                            VStack(alignment: .leading){
                                Text("Hai Engineer!")
                                    .font(.system(size: 44, weight: .bold, design: .default))
                                    .foregroundColor(.white)
                                    .transition(.opacity)
                                Text("Kamu Punya 5 Tugas Hari Ini!")
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .transition(.opacity)
                            }
                            .padding(.horizontal, 45)
                            .padding(.top, 40)
                            .padding(.bottom, 20)
                        }
 
                        
                        WeekView(selectedDate: $selectedDate)
                            .padding(.top, 20)
                            .animation(.easeInOut(duration: 0.5), value:showGreeting)
                        
                        Spacer()
                        
                        TaskListView(selectedDate: selectedDate)
                            .padding(.top, 8)
                            .padding(.bottom, -40)
                    }

                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
//            .onAppear {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
//                    withAnimation{
//                        showGreeting = false
//                    }
//                }
//            }
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

