//
//  Date+Extension.swift
//  Rouzzle
//
//  Created by 김정원 on 11/4/24.
//

import Foundation

extension Date {
    /// 06:30 식으로 변환하는 함수
    func formattedToTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 24시간 형식 (예: 06:30)
        return formatter.string(from: self)
    }
    
    // Date객채를 시간에 따라 아심, 점심, 저녁, 새벽으로 나누는 함수
    func getTimeCategory() -> TimeCategory {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        let minute = calendar.component(.minute, from: self)
        let totalMinutes = hour * 60 + minute
        
        switch totalMinutes {
        case 300..<720: // 05:00 - 11:59
            return .morning
        case 720..<1080: // 12:00 - 17:59
            return .afternoon
        case 1080..<1380: // 18:00 - 22:59
            return .evening
        default:
            return .night
        }
    }
}
