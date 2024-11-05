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
    var timerState: TimerState = .running
    var timeRemaining = 300 // 초기 타이머 시간 임시로 5분 설정
    private var timer: Timer?
    
    enum TimerState {
        case running
        case paused
    }
    
    // 타이머 상태 전환
    func toggleTimer() {
        if timerState == .running {
            timerState = .paused
        } else {
            timerState = .running
        }
    }
    
    // 타이머 시작
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timerState == .running && self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
        }
    }
    
    // 시간 문자열로 변환
    func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
