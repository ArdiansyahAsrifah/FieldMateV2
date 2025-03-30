//
//  Header.swift
//  FieldMateV2
//
//  Created by Muhammad Ardiansyah Asrifah on 26/03/25.
//

import SwiftUI

struct Header: View {
    @Binding var isShowingEventModal: Bool
    
    var body: some View {
        HStack {
            Button(action: {
                
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "wrench.and.screwdriver.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.colorTeal)
                    
                    Text("Field Mate!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.colorTeal)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                        .shadow(radius: 4)
                )

            }
        }
        .padding(.horizontal)
    }
}
