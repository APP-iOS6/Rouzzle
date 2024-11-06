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
}
