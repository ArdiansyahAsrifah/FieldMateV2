//
//  MeshGradientForCard.swift
//  FieldMateV2
//
//  Created by Muhammad Ardiansyah Asrifah on 07/04/25.
//

import SwiftUI

struct MeshGradientForCard: View {
    var body: some View {
        GeometryReader { geometry in
            let colors = [
                Color(hex: "#3DD9B8"),
                Color(hex: "#55ABFA"),
                Color(hex: "#3E77F7"),
                Color(hex: "#3DD9B8"),
                Color(hex: "#55ABFA")
            ]

            let points = [
                CGPoint(x: 0.2, y: 0.3),
                CGPoint(x: 0.8, y: 0.2),
                CGPoint(x: 0.6, y: 0.8),
                CGPoint(x: 0.3, y: 0.6)
            ]

            ZStack {
                ForEach(0..<colors.count, id: \.self) { index in
                    Circle()
                        .fill(colors[index])
                        .frame(width: geometry.size.width * 0.8)
                        .position(
                            x: geometry.size.width * points[index % points.count].x,
                            y: geometry.size.height * points[index % points.count].y
                        )
                        .blur(radius: 100)
                }
            }
        }
    }
}
