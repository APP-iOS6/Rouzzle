//
//  TimerState.swift
//  Rouzzle
//
//  Created by 김정원 on 11/11/24.
//

import Foundation
import SwiftUI

enum TimerState {
    case running
    case paused
    case overtime
    
    var gradientColors: [Color] {
        switch self {
        case .running:
            return [.white, Color(.playBackground)]
        case .paused:
            return [.white, Color(.pauseBackground)]
        case .overtime:
            return [.white, Color(.overtimeBackground)]
        }
    }
    
    var puzzleTimerColor: Color {
        switch self {
        case .overtime:
            return Color(.overtimePuzzleTimer)
        case .running:
            return Color.themeColor
        case .paused:
            return Color(.pausePuzzleTimer)
        }
    }
    
    var timeTextColor: Color {
        switch self {
        case .overtime:
            return Color(.overtimePuzzleTimer)
        case .running:
            return .accent
        case .paused:
            return .white
        }
    }
    
}
