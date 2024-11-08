//
//  RoutineStartViewModel.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/5/24.
//

import Foundation
import Observation
import SwiftUI

enum TimerState {
    case running
    case paused
    case overtime
}

@Observable
class RoutineStartViewModel {
    var timerState: TimerState = .running
    private var timer: Timer?
    
    var timeRemaining: Int = 0
    
    var tasks = DummyTask.tasks
    
    private let playBackgroundColor = Color.fromRGB(r: 252, g: 255, b: 240)
    private let pauseBackgroundColor = Color.fromRGB(r: 230, g: 235, b: 212)
    private let overtimeBackgroundColor = Color.fromRGB(r: 255, g: 242, b: 226)
    
    private let pausePuzzleTimerColor = Color.fromRGB(r: 191, g: 207, b: 154)
    private let overtimePuzzleTimerColor = Color.fromRGB(r: 255, g: 211, b: 172)
    
    let overtimeTextColor = Color.fromRGB(r: 245, g: 71, b: 28)

    var gradientColors: [Color] {
        switch timerState {
        case .running:
            return [.white, playBackgroundColor]
        case .paused:
            return [.white, pauseBackgroundColor]
        case .overtime:
            return [.white, overtimeBackgroundColor]
        }
    }
    
    // 퍼즐 모양 배경색
    var puzzleTimerColor: Color {
        switch timerState {
        case .overtime:
            return overtimePuzzleTimerColor
        case .running:
            return Color.themeColor
        case .paused:
            return pausePuzzleTimerColor
        }
    }
    
    var timeTextColor: Color {
        timerState == .overtime ? overtimeTextColor : (timerState == .running ? .accent : .white)
    }
    
    var inProgressTask: DummyTask? {
        tasks.first { $0.taskStatus == .inProgress }
    }
    
    var nextPendingTask: DummyTask? {
        tasks
            .drop(while: { $0.taskStatus != .inProgress })
            .dropFirst()
            .first(where: { $0.taskStatus == .pending })
    }
    
    var isRoutineCompleted = false // 모든 작업 완료 여부 체크
    
    init() {
        timeRemaining = inProgressTask?.timer ?? 0
    }
    
    // 타이머 시작
    func startTimer() {
        timer?.invalidate()
        guard timerState == .running || timerState == .overtime else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.timeRemaining -= 1
            if self.timeRemaining < 0 {
                self.timerState = .overtime
            }
        }
    }
    
    func toggleTimer() {
        if timerState == .running || timerState == .overtime {
            timerState = .paused
        } else {
            timerState = timeRemaining >= 0 ? .running : .overtime
        }
        startTimer()
    }
    
    // 완료 버튼 로직(inProgress 상태에서 completed로 변경)
    func markTaskAsCompleted() {
        guard let inProgressIndex = tasks.firstIndex(where: { $0.taskStatus == .inProgress }) else { return }
        
        tasks[inProgressIndex].taskStatus = .completed
        
        if let nextPendingIndex = tasks[inProgressIndex...].firstIndex(where: { $0.taskStatus == .pending }) {
            tasks[nextPendingIndex].taskStatus = .inProgress
            timeRemaining = tasks[nextPendingIndex].timer ?? 0
        } else {
            isRoutineCompleted = true
        }
    }
    
    // 스킵 버튼 로직(inProgress 상태에서 pending으로 변경)
    func skipTask() {
        guard let inProgressIndex = tasks.firstIndex(where: { $0.taskStatus == .inProgress }) else { return }
        
        tasks[inProgressIndex].taskStatus = .pending
        
        if let nextPendingIndex = tasks[(inProgressIndex + 1)...].firstIndex(where: { $0.taskStatus == .pending }) {
            tasks[nextPendingIndex].taskStatus = .inProgress
            timeRemaining = tasks[nextPendingIndex].timer ?? 0
        } else {
            isRoutineCompleted = true
        }
    }
}

// MARK: - 테스트용 더미 데이터
struct DummyTask: Identifiable {
    let id = UUID()
    var taskStatus: TaskStatus
    let emoji: String
    let title: String
    let timer: Int?
    
    static var tasks = [
        DummyTask(taskStatus: .completed, emoji: "☕️", title: "커피/차 마시기", timer: 600),
        DummyTask(taskStatus: .inProgress, emoji: "💊", title: "유산균 먹기", timer: 10),
        DummyTask(taskStatus: .pending, emoji: "🐱", title: "시간 없는 테스트 할일", timer: nil),
        DummyTask(taskStatus: .pending, emoji: "🧼", title: "설거지 하기", timer: 600),
        DummyTask(taskStatus: .pending, emoji: "👕", title: "옷 갈아입기", timer: 300)
    ]
}
