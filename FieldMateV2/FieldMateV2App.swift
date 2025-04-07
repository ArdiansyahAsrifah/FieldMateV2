//
//  FieldMateV2App.swift
//  FieldMateV2
//
//  Created by Muhammad Ardiansyah Asrifah on 26/03/25.
//

import SwiftUI
import ActivityKit

@main
struct FieldMateApp: App {
    @State private var activity: Activity<FieldMateLiveActivityAttributes>?

    var body: some Scene {
        WindowGroup {
            CalendarView()
                .onAppear {
                    startLiveActivity()
                }
        }
    }

    private func startLiveActivity() {
        let attributes = FieldMateLiveActivityAttributes(taskID: "1234")
        let initialState = FieldMateLiveActivityAttributes.ContentState(
            taskTitle: "Cek AC",
            taskTime: "09:30 AM",
            taskLocation: "Apple Developer Academy",
            taskListTimes: ["08:00", "09:30", "11:00", "14:00"]
        )

        do {
            activity = try Activity<FieldMateLiveActivityAttributes>.request(
                attributes: attributes,
//                contentState: state,
                content: .init(state: initialState, staleDate: nil),
                pushType: nil
            )
            print("✅ Live Activity dimulai!")
        } catch {
            print("❌ Gagal memulai Live Activity: \(error.localizedDescription)")
        }
    }
}
