//
//  FormTable.swift
//  FieldMateV2
//
//  Created by Muhammad Ardiansyah Asrifah on 27/03/25.
//

import SwiftUI

struct ConditionField: View {
    let suggestions: [String] = [
        "Good",
        "Fair",
        "Dirty",
        "Worn",
        "Clogged",
        "Leaking"
    ]
    
    @Binding var condition: String
    
    @State private var showSuggestions: Bool = false
    
    var filteredSuggestions: [String] {
        if condition.isEmpty { return suggestions }
        return suggestions.filter { $0.lowercased().contains(condition.lowercased()) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TextField("Enter Condition", text: $condition)
                .textFieldStyle(.roundedBorder)
                .onChange(of: condition) { newValue in
                    showSuggestions = !newValue.isEmpty
                }
            
            if showSuggestions && !filteredSuggestions.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(filteredSuggestions, id: \.self) { suggestion in
                        Text(suggestion)
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .onTapGesture {
                                condition = suggestion
                                showSuggestions = false
                            }
                        Divider()
                    }
                }
                .background(Color(UIColor.systemBackground))
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            }
        }
//        .animation(.default, value: showSuggestions)
    }
}

struct CheckRow: Identifiable {
    let id = UUID()
    var checkName: String
    var condition: String = ""
    var action: String = ""
}

struct CheckItemRow: View {
    var checkName: String
    @Binding var condition: String
    @Binding var action: String
    
    var body: some View {
        HStack {
 
            Text(checkName)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ConditionField(condition: $condition)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("Enter Action", text: $action)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 4)
    }
}

struct CheckListTable: View {
    @Binding var rows: [CheckRow]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Check List")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Condition")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Action")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 8)
            Divider()
            
            ForEach($rows) { $row in
                CheckItemRow(checkName: row.checkName,
                             condition: $row.condition,
                             action: $row.action)
                Divider()
            }
        }
        .padding()
    }
}
