//
//  String+Extension.swift
//  Rouzzle
//
//  Created by 김정원 on 11/8/24.
//

import Foundation

extension String {
    /// "HH:mm" 형식의 24시간 시간을 받아서 12시간 형식의 시간을 반환합니다.
    func to12HourFormattedTime() -> String {
        let components = self.split(separator: ":").compactMap { Int($0) }
        
        // 유효한 "HH:mm" 형식인지 확인
        guard components.count == 2, components[0] >= 0, components[0] < 24, components[1] >= 0, components[1] < 60 else {
            return "00:00"
        }
        
        let hour24 = components[0]
        let minute = components[1]
        
        // 12시간 형식으로 변환
        let hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12
        return String(format: "%02d:%02d", hour12, minute)
    }
    
    /// "HH:mm" 형식의 24시간 시간을 받아서 "AM" 또는 "PM"을 반환합니다.
    func to12HourPeriod() -> String {
        let components = self.split(separator: ":").compactMap { Int($0) }
        
        // 유효한 "HH:mm" 형식인지 확인
        guard components.count == 2, components[0] >= 0, components[0] < 24 else {
            return "00:00"
        }
        
        let hour24 = components[0]
        return hour24 < 12 ? "AM" : "PM"
    }
}
