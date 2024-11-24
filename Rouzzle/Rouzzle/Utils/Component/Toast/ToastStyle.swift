//
//  ToastStyle.swift
//  ToastTest2
//
//  Created by 이다영 on 11/13/24.
//

import SwiftUI

enum ToastStyle {
    case error
    case warning
    case success
    case info
    case getOnePuzzle
    case getTwoPuzzle
    
    var themeColor: Color {
        switch self {
        case .error: return Color.red
        case .warning: return Color.orange
        case .info: return Color.blue
        case .success: return Color.green
        case .getOnePuzzle: return Color.gray.opacity(0.9)
        case .getTwoPuzzle: return Color.gray.opacity(0.9)
        }
    }
    
    var iconFileName: String {
        switch self {
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .getOnePuzzle: return "Piece"
        case .getTwoPuzzle: return "puzzlepiece.fill"
        }
    }
}
