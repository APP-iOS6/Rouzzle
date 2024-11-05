//
//  RoutineStartViewModel.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/5/24.
//

import Foundation
import Observation

@Observable
class RoutineStartViewModel {
    var isRunning: Bool = true // 타이머 실행 여부
    var timeRemaining = 300 // 초기 타이머 시간 임시로 5분 설정
    private var timer: Timer?

    // 타이머 시작
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.isRunning && self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
        }
    }
}
