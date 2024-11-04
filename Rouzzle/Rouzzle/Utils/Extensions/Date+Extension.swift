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
}
