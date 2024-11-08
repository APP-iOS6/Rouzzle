//
//  String+Extension.swift
//  Rouzzle
//
//  Created by 김정원 on 11/8/24.
//

import Foundation

extension String {
    /// "HH:mm" 형식의 24시간 시간을 받아서 12시간 형식의 시간과 AM/PM 여부를 반환
    func to12HourFormat() -> (formattedTime: String, period: String)? {
        let components = self.split(separator: ":").compactMap { Int($0) }
        
        guard components.count == 2, components[0] >= 0, components[0] < 24, components[1] >= 0, components[1] < 60 else {
            return nil
        }
        
        let hour24 = components[0]
        let minute = components[1]
        
        let period = (hour24 < 12) ? "AM" : "PM"
        
        let hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12
        let formattedTime = String(format: "%02d:%02d", hour12, minute)
        
        return (formattedTime, period)
    }
}
