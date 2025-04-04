//
//  TaskDetailView.swift
//  FieldMateV2
//
//  Created by Muhammad Ardiansyah Asrifah on 26/03/25.
//


import FieldMateLiveActivityExtension
import SwiftUI
import ActivityKit
import PDFKit

struct TaskDetailView: View {
    let task: CalendarTask
    @State private var selectedDate: Date
    @State private var isRescheduling = false
    @State private var selectedCategory: String = "AC"
    @State private var isCompleted: Bool = false

    let categories = ["AC", "Water Sprinkle", "Fire Alarm", "Lamp"]
//    @State private var formResponses: [String: String] = [:]
//    @State private var filledTable: [(String, String, String)] = []
    @State private var checkRows: [CheckRow] = []
    
    init(task: CalendarTask) {
        self.task = task
        _selectedDate = State(initialValue: task.startTime)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                Text(task.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(task.description)
                    .font(.body)
                    .foregroundColor(.gray)
                
//                Button(action: {
//                    startLiveActivity(task: task)
//                }) {
//                    Text("Mulai Live Activity")
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.green)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
                
                Divider()
                
//                VStack(alignment: .leading){
                    HStack{
                        Text("Waktu Tugas: ")
                            .font(.headline)
                        
                        Button(action: {
                            withAnimation {
                                isRescheduling.toggle()
                            }
                        }) {
                            Text("\(formattedTime(date: selectedDate))")
                                .font(.headline)
                                .fontWeight(.regular)
                                .foregroundColor(.blue)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }
                    }
                    
                    HStack{
                        Text("Pilih Kategori:")
                            .font(.headline)
//                            .frame(maxWidth: 100)
                        Picker("Kategori", selection: $selectedCategory) {
                            ForEach(categories, id: \.self) { category in
                                Text(category).tag(category)
                                    .font(.headline)
                                
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                    
//                }
                
                
                if isRescheduling {
                    DatePicker("Pilih Waktu", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                
                Divider()
                
                
                
                      
                // Pass binding of checkRows to the CheckListTable
                if !checkRows.isEmpty {
                    CheckListTable(rows: $checkRows)
                }
                Button(action: {
                    isCompleted.toggle()
                }) {
                    HStack {
                        Spacer() // Memberikan ruang di kiri agar tombol tetap di tengah
                        Button(action: {
                            isCompleted.toggle()
                        }) {
                            HStack {
                                Image(systemName: isCompleted ? "checkmark.square.fill" : "square")
                                    .foregroundColor(isCompleted ? .green : .gray)
                                    .font(.title)
                                
                                Text(isCompleted ? "Selesai" : "Belum Selesai")
                                    .font(.headline)
                                    .foregroundColor(isCompleted ? .green : .red)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                        Spacer() // Memberikan ruang di kanan agar tombol tetap di tengah
                    }
                }

                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                Button(action: {
                    let filledTable = checkRows.map { ($0.checkName, $0.condition, $0.action) }
                    exportToPDF(category: selectedCategory, tableData: filledTable)
                }) {
                    Text("Export ke PDF")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isCompleted ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 10)
                .disabled(!isCompleted)
                
                
                
                

            }
            .padding()
            .onAppear {
                if let tableData = getTableData(for: selectedCategory), checkRows.isEmpty {
                    // Initialize checkRows once when the view appears
                    self.checkRows = tableData.map { (checkName, defaultCondition, defaultAction) in
                        CheckRow(checkName: checkName, condition: defaultCondition, action: defaultAction)
                    }
                }
            }
            .onChange(of: selectedCategory) { newCategory in
                if let tableData = getTableData(for: newCategory) {
                    self.checkRows = tableData.map { (checkName, defaultCondition, defaultAction) in
                        CheckRow(checkName: checkName, condition: defaultCondition, action: defaultAction)
                    }
                }
            }

            
        }
        .navigationTitle("Task Detail")
    }
    
    
    func formattedTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    func getTableData(for category: String) -> [(String, String, String)]? {
        switch category {
        case "AC":
            return [("Filter", "Baik", "Tidak Ada"), ("Freon", "Baik", "Tidak Ada"), ("Kompresor", "Baik", "Tidak Ada")]
        case "Water Sprinkle":
            return [("Pompa", "Baik", "Tidak Ada"), ("Nozzle", "Baik", "Tidak Ada"), ("Pipa", "Baik", "Tidak Ada")]
        case "Fire Alarm":
            return [("Sensor", "Baik", "Tidak Ada"), ("Sirine", "Baik", "Tidak Ada"), ("Panel", "Baik", "Tidak Ada")]
        case "Lamp":
            return [("Lampu LED", "Baik", "Tidak Ada"), ("Kabel", "Baik", "Tidak Ada"), ("Sakelar", "Baik", "Tidak Ada")]
        default:
            return nil
        }
    }
    
    func startLiveActivity(task: CalendarTask) {
        let attributes = FieldMateLiveActivityAttributes(taskID: task.id.uuidString)
        let initialState = FieldMateLiveActivityAttributes.ContentState(
            taskTitle: task.title,
            taskTime: formattedTime(date: task.startTime),
            taskLocation: task.description
        )

        do {
            let activity = try Activity<FieldMateLiveActivityAttributes>.request(
                attributes: attributes,
//                contentState: state,
                content: .init(state: initialState, staleDate: nil),
                pushType: nil
            )
            print("✅ Live Activity dimulai: \(activity.id)")
        } catch {
            print("❌ Gagal memulai Live Activity: \(error)")
        }
    }
    

    
    func checkActiveLiveActivities() {
        let activities = Activity<FieldMateLiveActivityAttributes>.activities
        print("📌 Jumlah Live Activity aktif: \(activities.count)")
        for activity in activities {
            print("🔍 Active Live Activity ID: \(activity.id)")
        }
    }


    func ActivityManually(task: CalendarTask) {
        Task {
            for activity in Activity<FieldMateLiveActivityAttributes>.activities {
                await activity.update(using: FieldMateLiveActivityAttributes.ContentState(
                    taskTitle: "🔄 Updated: \(task.title)",
                    taskTime: formattedTime(date: task.startTime),
                    taskLocation: task.description
                ))
                print("🔄 Live Activity diperbarui dengan konten baru!")
            }
        }
    }



    func stopLiveActivity() {
        Task {
            let activities = Activity<FieldMateLiveActivityAttributes>.activities
            for activity in activities {
                await activity.end(dismissalPolicy: .immediate)
            }
        }
    }
    
    func exportToPDF(category: String, tableData: [(String, String, String)]) {
//        let pdfDocument = PDFDocument()
        let pdfPage = PDFPageView(
            taskTitle: task.title,
            taskDescription: task.description,
            category: category,
//            data: formResponses,
            data: tableData,
            isCompleted: isCompleted
        )
        
        let pdfPageView = UIHostingController(rootView: pdfPage).view!
        pdfPageView.frame = CGRect(x: 0, y: 0, width: 612, height: 792)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pdfPageView.bounds)
        let data = renderer.pdfData { context in
            context.beginPage()
            pdfPageView.drawHierarchy(in: pdfPageView.bounds, afterScreenUpdates: true)
        }
        
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("Form_\(category).pdf")
        try? data.write(to: tempURL)
        
        let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.rootViewController?.present(activityVC, animated: true)
        }
    }
}



struct PDFPageView: View {
    let taskTitle: String
    let taskDescription: String
    let category: String
    let data: [(String, String, String)]
    let isCompleted: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Laporan Inspeksi")
                .font(.largeTitle)
                .bold()
            
            Text(taskTitle)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            Text(taskDescription)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Text(isCompleted ? "✅ Status: Selesai" : "⏳ Status: Belum Selesai")
                .font(.headline)
                .foregroundColor(isCompleted ? .green : .red)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            ForEach(data.sorted { $0.0 < $1.0 }, id: \.0) { item in
                HStack {
                    Text(item.0)
                        .bold()
                        .frame(width: 180, alignment: .leading)
                    Text(item.1)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            Spacer()
        }
        .padding()
    }
}


#Preview("Light Mode") {
    CalendarView()
        .preferredColorScheme(.light)
}
