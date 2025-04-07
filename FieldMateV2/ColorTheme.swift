//
//  ColorTheme.swift
//  FieldMateV2
//
//  Created by Muhammad Ardiansyah Asrifah on 26/03/25.
//

import SwiftUI

extension Color {
    // Brand Colors
    static let appBlue = Color("ColorBlue")
    static let appGreen = Color("ColorGreen")
    static let appOrange = Color("ColorOrange")
    static let appPink = Color("ColorPink")
    static let appPurple = Color("ColorPurple")
    static let appTeal = Color("ColorTeal")
    
    // Semantic Colors
    static let appBackground = Color("ColorBackground")
    static let appBorder = Color("Border")
    
    // Container Colors
    static let appContainer = Color("Container")
    static let appContainerSecondary = Color("ContainerSecondary")
    
    // Text Colors
    static let appTextPrimary = Color("TextPrimary")
    static let appTextSecondary = Color("TextSecondary")
    
    init(hex: String) {
           let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
           var int: UInt64 = 0
           Scanner(string: hex).scanHexInt64(&int)

           let a, r, g, b: UInt64
           switch hex.count {
           case 3:
               (a, r, g, b) = (255, (int >> 8) * 17,
                               (int >> 4 & 0xF) * 17,
                               (int & 0xF) * 17)
           case 6:
               (a, r, g, b) = (255,
                              int >> 16,
                              int >> 8 & 0xFF,
                              int & 0xFF)
           case 8:
               (a, r, g, b) = (int >> 24,
                              int >> 16 & 0xFF,
                              int >> 8 & 0xFF,
                              int & 0xFF)
           default:
               (a, r, g, b) = (255, 0, 0, 0)
           }

           self.init(
               .sRGB,
               red: Double(r) / 255,
               green: Double(g) / 255,
               blue: Double(b) / 255,
               opacity: Double(a) / 255
           )
       }
}
