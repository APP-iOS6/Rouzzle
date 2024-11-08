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
    private var timer: Timer?
    
    var timeRemaining: Int = 0
    
    var tasks = DummyTask.tasks
    
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
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.isRunning && self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
        }
    }
    
    // 완료 버튼 로직(inProgress 상태에서 completed로 변경)
    func markTaskAsCompleted() {
        guard let inProgressIndex = tasks.firstIndex(where: { $0.taskStatus == .inProgress }) else { return }
        
        tasks[inProgressIndex].taskStatus = .completed
        
        if let nextPendingIndex = tasks[inProgressIndex...].firstIndex(where: { $0.taskStatus == .pending }) {
            tasks[nextPendingIndex].taskStatus = .inProgress
            timeRemaining = tasks[nextPendingIndex].timer
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
            timeRemaining = tasks[nextPendingIndex].timer
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
    let timer: Int
    
    static var tasks = [
        DummyTask(taskStatus: .completed, emoji: "☕️", title: "커피/차 마시기", timer: 600),
        DummyTask(taskStatus: .inProgress, emoji: "💊", title: "유산균 먹기", timer: 300),
        DummyTask(taskStatus: .pending, emoji: "🧼", title: "설거지 하기", timer: 600),
        DummyTask(taskStatus: .pending, emoji: "👕", title: "옷 갈아입기", timer: 300)
    ]
}
