//
//  ToastModel.swift
//  ToastTest2
//
//  Created by 이다영 on 11/13/24.
//

import SwiftUI

struct ToastModel: Equatable {
    var type: ToastStyle
    var message: String
    var duration: Double = 3
    
    // 스타일에 따른 기본 타이틀과 메시지로 초기화
    init(type: ToastStyle, message: String? = nil, duration: Double = 3) {
        self.type = type
        
        // 고정 메시지(get퍼즐만)
        if type == .getOnePuzzle {
            self.message = "+1획득!"
        } else if type == .getTwoPuzzle {
            self.message = "+2획득!"
        } else {
            self.message = message ?? ""
        }
        
        self.duration = duration
    }
}
