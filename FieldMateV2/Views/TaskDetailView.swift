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
                    .offset(x: 100, y: -200)
                    .zIndex(1)
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    VStack(alignment:.leading, spacing: 20){
                        VStack(alignment: .leading){
                            Text(task.title)
                                .font(.system(size: 44, weight: .bold, design: .default))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .foregroundColor(colorScheme == .dark ? .black : .white)
                            
                    
                            Text(task.description)
                                .font(.body)
                                .foregroundColor(.white)
                        }
                        
                        
                        HStack{
                            Text("Waktu Tugas: ")
                                .font(.headline)
                                .foregroundColor(.white)
                            
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
                                    .background(colorScheme == .dark ? .black : .white)
                                    .cornerRadius(10)
                            }
                        }
                        
                        //                    HStack{
                        //                        Text("Pilih Kategori:")
                        //                            .font(.headline)
                        ////                            .frame(maxWidth: 100)
                        //                        Picker("Kategori", selection: $selectedCategory) {
                        //                            ForEach(categories, id: \.self) { category in
                        //                                Text(category).tag(category)
                        //                                    .font(.headline)
                        //
                        //                            }
                        //                        }
                        //                        .pickerStyle(MenuPickerStyle())
                        //                        .padding()
                        //                        .background(Color(.systemGray6))
                        //                        .cornerRadius(10)
                        //                    }
                        
                        //                }
                        
                        
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
                    
                    //                Divider()
                    // Pass binding of checkRows to the CheckListTable
                    if !checkRows.isEmpty {
                        VStack{
                            CheckListTable(rows: $checkRows)
                                .padding(.bottom, 30)
                            
//                            Button(action: {
//                                isCompleted.toggle()
//                            }) {
//                                HStack {
//                                    Spacer() // Memberikan ruang di kiri agar tombol tetap di tengah
//                                    Button(action: {
//                                        isCompleted.toggle()
//                                    }) {
//                                        HStack {
//                                            Image(systemName: isCompleted ? "checkmark.square.fill" : "square")
//                                                .foregroundColor(isCompleted ? .green : .gray)
//                                                .font(.title)
//                                            
//                                            Text(isCompleted ? "Selesai" : "Belum Selesai")
//                                                .font(.headline)
//                                                .foregroundColor(isCompleted ? .green : .red)
//                                        }
//                                        .padding()
//                                        .background(Color(.systemGray6))
//                                        .cornerRadius(10)
//                                    }
//                                    Spacer() // Memberikan ruang di kanan agar tombol tetap di tengah
//                                }
//                            }
//                            .padding()
//                            .background(Color(.systemGray6))
//                            .cornerRadius(10)
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
//                            .disabled(!isCompleted)
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
                        // Initialize checkRows once when the view appears
                        self.checkRows = tableData.map { (checkName, defaultCondition, defaultAction) in
                            CheckRow(checkName: checkName, condition: defaultCondition, action: defaultAction)
                        }
                    }
                }
                .onChange(of: selectedTask) { newCategory in
                    if let tableData = getTableData(for: newCategory) {
                        self.checkRows = tableData.map { (checkName, defaultCondition, defaultAction) in
                            CheckRow(checkName: checkName, condition: defaultCondition, action: defaultAction)
                        }
                    }
                }
                
            }
        }
        .navigationTitle("Detil Tugas")
//        .toolbarBackground(, for: .navigationBar)
//        .toolbarBackgroundVisibility(., for: <#T##ToolbarPlacement...##ToolbarPlacement#>)
    }
    
    
    func formattedTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    func getTableData(for selectedTask: String) -> [(String, String, String)]? {
        switch task.title {
        case "Cek AC":
            return [("Filter", "Baik", "Tidak Ada"), ("Freon", "Baik", "Tidak Ada"), ("Kompresor", "Baik", "Tidak Ada")]
        case "Preventif Lift":
            return [("Sensor Pintu", "Baik", "Tidak Ada"), ("Motor", "Baik", "Tidak Ada"), ("Katrol", "Baik", "Tidak Ada")]
        case "Pintu Utama Rusak":
            return [("Sensor", "Baik", "Tidak Ada"), ("Akses keamanan", "Baik", "Tidak Ada"), ("Auto lock", "Baik", "Tidak Ada")]
        case "Flush Toilet":
            return [("Sumber Air", "Baik", "Tidak Ada"), ("Pompa Air", "Baik", "Tidak Ada"), ("Saluran Keluar", "Baik", "Tidak Ada")]
        case "Penggantian Lampu":
            return [("Arus Listrik", "Baik", "Tidak Ada"), ("Bola Lampu", "Baik", "Tidak Ada"), ("Kabel", "Baik", "Tidak Ada")]
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
                await activity.update(using: FieldMateLiveActivityAttributes.ContentState(
                    taskTitle: "🔄 Updated: \(task.title)",
                    taskTime: formattedTime(date: task.startTime),
                    taskLocation: task.description,
                    taskListTimes: ["09:00", "11:00", "14:00"]
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
            
//            Text(isCompleted ? "✅ Status: Selesai" : "⏳ Status: Belum Selesai")
//                .font(.headline)
//                .foregroundColor(isCompleted ? .green : .red)
//                .padding()
//                .background(Color(.systemGray6))
//                .cornerRadius(10)
            
            Spacer()
            
            
        }
        .padding()
    }
}


#Preview() {
    TaskDetailView(task: CalendarTask.sampleTasks[0])
}
