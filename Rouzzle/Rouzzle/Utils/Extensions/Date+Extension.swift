//
//  Date+Extension.swift
//  Rouzzle
//
//  Created by 김정원 on 11/4/24.
//

import Foundation

extension Date {
    /// 날짜를 "h:mm a" 형식(예: "1:36 PM")으로 반환
    func toTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a" // 시간과 분, AM/PM 형식
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: self)
    }
    
    /// 06:30 식으로 변환하는 함수
    func formattedToTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 24시간 형식 (예: 06:30)
        return formatter.string(from: self)
    }
    
    /// 05시: 30분 으로 변환하는 함수
    var formattedToTimeDetail: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH시 mm분" // 24시간 형식 (예: 06:30)
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
    
    var formattedDateToString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR") // 한국 로케일// 필요에 따라 타임존 설정
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: self)
    }
    
    var formattedDateToday: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR") // 한국 로케일// 필요에 따라 타임존 설정
        formatter.dateFormat = "yyyy년MM월dd일"
        return formatter.string(from: self)
    }
    
    var extraData: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        
        formatter.dateFormat = "MM"
        let month = formatter.string(from: self)
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: self)
        
        return "\(year)년 \(month)월"
    }
    
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
}
