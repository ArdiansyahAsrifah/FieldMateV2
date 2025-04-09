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
    @State private var selectedTask: String
    @Environment(\.colorScheme) var colorScheme
    
    let categories = ["AC", "Preventif Lift", "Pintu Utama Rusak", "Flush Toilet" ,  "Penggantian Lampu"]
    @State private var checkRows: [CheckRow] = []
    
    init(task: CalendarTask) {
        self.task = task
        _selectedDate = State(initialValue: task.startTime)
        _selectedTask = State(initialValue: task.title)
    }
    
    var body: some View {
        ScrollView {
            ZStack{
                
                AnimatedBackground()
                    .ignoresSafeArea()
                
                
                Image(task.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .opacity(0.2)
                    .padding(.top, -300)
                    .padding(.trailing, -200)
                    .zIndex(1)
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    VStack(alignment:.leading, spacing: 25){
                        VStack(alignment: .leading){
                            Text(task.title)
                                .font(.system(size: 44, weight: .bold, design: .default))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .foregroundColor(colorScheme == .dark ? .black : .white)
                            
                    
                            Text(task.description)
                                .font(.body)
                                .foregroundColor(.white)
                            
                            Spacer()
                            Spacer()
                            Spacer()
                            
                            Text("\(formattedDateMonth(date: task.startTime))  \(formattedTime(date: selectedDate))")
                                .font(.title3)
                                .fontWeight(.semibold)
//                                .fontWeight(.medium)
//                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .foregroundColor(.white)
                        }
                        
                        
//                        HStack{
//                            Text("\(formattedDateMonth(date: task.startTime))  \(formattedTime(date: selectedDate))")
//                                .font(.subheadline)
//                                .fontWeight(.medium)
////                                .foregroundColor(colorScheme == .dark ? .white : .black)
//                                .foregroundColor(.white)
////                                .background(colorScheme == .dark ? .black : .white)
//                            
////                            Text("\(formattedTime(date: selectedDate))")
////                                .font(.headline)
////                                .fontWeight(.regular)
////                                .foregroundColor(colorScheme == .dark ? .white : .black)
////                                .padding(.top, 0)
////                                .padding(.horizontal, 16)
////                                .padding(.vertical, 5)
////                                .background(colorScheme == .dark ? .black : .white)
////                                .cornerRadius(10)
//                            
//    
//                        }
//                        
                        if isRescheduling {
                            DatePicker("Pilih Waktu", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .environment(\.locale, Locale(identifier: "id_ID"))
                        }
                        
                    }
                    .padding(10)
                    .padding(.bottom, -15)
                    
                    
                    if !checkRows.isEmpty {
                        VStack{
                            CheckListTable(rows: $checkRows)
                                .padding(.bottom, 30)
                            
                            Button(action: {
                                let filledTable = checkRows.map { ($0.checkName, $0.condition, $0.action) }
                                exportToPDF(category: selectedCategory, tableData: filledTable)
                            }) {
                                Text("Export ke PDF")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding(.top, 10)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(colorScheme == .dark ? .black : .white)
                        .cornerRadius(20)
                        
                    }
                
                }
                .padding(20)
                
                .onAppear {
                    if let tableData = getTableData(for: selectedTask), checkRows.isEmpty {
                        self.checkRows = tableData.map { (checkName, defaultCondition, defaultAction) in
                            CheckRow(checkName: checkName, condition: defaultCondition, action: defaultAction)
                        }
                    }
                }
                .onChange(of: selectedTask) { _, newCategory in
                    if let tableData = getTableData(for: newCategory) {
                        self.checkRows = tableData.map { (checkName, defaultCondition, defaultAction) in
                            CheckRow(checkName: checkName, condition: defaultCondition, action: defaultAction)
                        }
                    }
                }
                
            }
        }
        .navigationTitle("Detail Tugas")
    }
    
    
    func formattedTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    
    func formattedDateMonth(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "EEEE, d MMMM yyyy"
        return formatter.string(from: date)
    }
    
    func getTableData(for selectedTask: String) -> [(String, String, String)]? {
        switch task.title {
        case "Cek AC":
            return [("Filter", "baik", "tidak ada"), ("Freon", "baik", "tidak ada"), ("Kompresor", "baik", "tidak ada")]
        case "Preventif Lift":
            return [("Sensor Pintu", "baik", "tidak ada"), ("motor", "baik", "tidak ada"), ("Katrol", "baik", "tidak ada")]
        case "Pintu Utama Rusak":
            return [("Sensor", "baik", "tidak ada"), ("Akses keamanan", "baik", "tidak ada"), ("Auto lock", "baik", "tidak ada")]
        case "Flush Toilet":
            return [("Sumber Air", "baik", "tidak ada"), ("Pompa Air", "baik", "tidak ada"), ("Saluran Keluar", "baik", "tidak ada")]
        case "Penggantian Lampu":
            return [("Arus Listrik", "baik", "tidak ada"), ("Bola Lampu", "baik", "tidak ada"), ("Kabel", "baik", "tidak ada")]
        default:
            return nil
        }
    }
    
    func startLiveActivity(task: CalendarTask) {
        let attributes = FieldMateLiveActivityAttributes(taskID: task.id.uuidString)
        let initialState = FieldMateLiveActivityAttributes.ContentState(
            taskTitle: task.title,
            taskTime: formattedTime(date: task.startTime),
            taskLocation: task.description,
            taskListTimes: ["09:00", "11:00", "14:00"]
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
                let updatedState = FieldMateLiveActivityAttributes.ContentState(
                    taskTitle: "🔄 Updated: \(task.title)",
                    taskTime: formattedTime(date: task.startTime),
                    taskLocation: task.description,
                    taskListTimes: ["09:00", "11:00", "14:00"]
                )

                let content = ActivityContent(state: updatedState, staleDate: nil)

                await activity.update(content)
                print("🔄 Live Activity diperbarui dengan konten baru!")
            }
        }
    }

    func exportToPDF(category: String, tableData: [(String, String, String)]) {
        let pdfPage = PDFPageView(
            taskTitle: task.title,
            taskDescription: task.description,
            category: category,
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
                .padding(.leading, -280)
            
            Text(taskDescription)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.leading, -300)
            
            ForEach(data.sorted { $0.0 < $1.0 }, id: \.0) { item in
                HStack {
                    Text(item.0)
                        .bold()
                        .frame(width: 180)
                    Text(item.1)
                        .frame(maxWidth: .infinity)
                    Text(item.2)
                        .frame(maxWidth: .infinity)
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


#Preview() {
    TaskDetailView(task: CalendarTask.sampleTasks[0])
}

#Preview() {
    CalendarView()
}
