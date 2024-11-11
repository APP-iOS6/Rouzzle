//
//  Int+Extension.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/6/24.
//

import Foundation

extension Int {
    // 초 단위의 값을 "MM:SS" 형식의 문자열로 변환(예: 330초 -> 05:30)
    func toTimeString() -> String {
        let minutes = self / 60
        let seconds = self % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var dayString: String {
        switch self {
        case 0:
            return "일"
        case 1:
            return "월"
        case 2:
            return "화"
        case 3:
            return "수"
        case 4:
            return "목"
        case 5:
            return "금"
        case 6:
            return "토"
        default:
            return "일"
        }
    }
    
    var formattedTimer: String {
        if self >= 60 {
            let minutes = self / 60
            return "\(minutes)분"
        } else {
            return "\(self)초"
        }
    }
}
