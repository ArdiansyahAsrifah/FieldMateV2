//
//  RotatingGradientBackground.swift
//  FieldMateV2
//
//  Created by Muhammad Ardiansyah Asrifah on 07/04/25.
//

import SwiftUI

struct AnimatedBackground: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            MeshGradient()
                .hueRotation(.degrees(animate ? 45 : 0))
                .animation(Animation.easeInOut(duration: 5).repeatForever(autoreverses: true), value: animate)
                .ignoresSafeArea()
        }
        .onAppear {
            animate.toggle()
        }
    }
}

struct MeshGradient: View {
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
                CGPoint(x: 0.3, y: 0.6),
                CGPoint(x: 0.5, y: 0.5)
            ]

            ZStack {
                ForEach(0..<colors.count, id: \.self) { index in
                    Circle()
                        .fill(colors[index])
                        .frame(width: geometry.size.width * 1.2,
                               height: geometry.size.width * 1.2)
                        .position(x: geometry.size.width * points[index % points.count].x,
                                  y: geometry.size.height * points[index % points.count].y)
                        .blur(radius: 120)
                        .opacity(0.6)
                }
            }
        }
    }
}
