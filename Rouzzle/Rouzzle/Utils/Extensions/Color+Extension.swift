//
//  Color+Extension.swift
//  Rouzzle
//
//  Created by 김정원 on 11/3/24.
//

import SwiftUI

extension Color {
    /// RGB 컬러 형태로 나타낼 때 사용하는 메서드 기본 투명도는 1임. 
    static func fromRGB(r: Double, g: Double, b: Double, opacity: Double = 1) -> Color {
        return Color(red: r/255, green: g/255, blue: b/255, opacity: opacity)
    }
    
    static var subHeadlineFontColor: Color {
        return .fromRGB(r: 153, g: 153, b: 153)
    }
    
    static var themeColor: Color {
        return .fromRGB(r: 193, g: 235, b: 96)
    }
    
    /// F9F9F9
    static var backgroundLightGray: Color {
        return .fromRGB(r: 249, g: 249, b: 249)
    }
    
    /// BFDF8F
    static var partiallyCompletePuzzle: Color {
        return .fromRGB(r: 191, g: 223, b: 143)
    }
}
