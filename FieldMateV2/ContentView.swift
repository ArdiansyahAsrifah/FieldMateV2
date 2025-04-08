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
    @State private var showGreeting = false
    
    var body: some View {
            NavigationView {
                ZStack {
                    AnimatedBackground()

                    HStack {
                        Spacer()
                        Image("engineer-05")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300)
                            .padding(.top, -480)
                            .padding(.trailing, -20)
                            .opacity(0.5)
                            .zIndex(1)
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        if showGreeting {
                            VStack(alignment: .leading){
                                Text("Hai Engineer!")
                                    .font(.system(size: 44, weight: .bold, design: .default))
                                    .foregroundColor(.white)

                                Text("Kamu Punya \(CalendarTask.sampleTasks.count) Tugas Hari Ini!")
                                    .font(.body)
                                    .foregroundColor(.white)

                            }
                            .padding(.horizontal, 45)
                            .padding(.top, 40)
                            .padding(.bottom, 20)
                        }

                        WeekView(selectedDate: $selectedDate)
                            .padding(.top, 20)
                            .animation(.easeInOut(duration: 0.5), value: showGreeting)

                        Spacer()

                        TaskListView(selectedDate: selectedDate)
                            .padding(.top, 8)
                            .padding(.bottom, -40)
                    }

//                    // Add image overlay in top-right
//                    VStack {
//                        HStack {
//                            Spacer()
//                            Image("engineer-05")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 300)
//                                .padding(.top, -90)
//                                .padding(.trailing, -30)
//                                .opacity(0.5)
//                                .zIndex(1)
//                        }
//                        Spacer()
//                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                withAnimation{
                    showGreeting = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                    withAnimation{
                        showGreeting = false
                    }
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

