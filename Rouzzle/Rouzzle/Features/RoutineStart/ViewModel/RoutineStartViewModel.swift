//
//  RoutineStartViewModel.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/5/24.
//

import Foundation
import Observation
import SwiftUI

@Observable
class RoutineStartViewModel {
    private var timer: Timer?
    var timerState: TimerState = .running
    var timeRemaining: Int
    var routineItem: RoutineItem
    
    var inProgressTask: TaskList? {
        routineItem.taskList.first { !$0.isCompleted }
    }
    
    var nextPendingTask: TaskList? {
        routineItem.taskList
            .drop(while: { $0.isCompleted })
            .dropFirst()
            .first(where: { !$0.isCompleted })
    }
    
    var isRoutineCompleted = false // 모든 작업 완료 여부 체크
    
    init(routineItem: RoutineItem) {
        self.routineItem = routineItem
        self.timeRemaining = routineItem.taskList.first?.timer ?? 0
    }
    // 타이머 시작
    func startTimer() {
        timer?.invalidate()
        guard timerState == .running || timerState == .overtime else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeRemaining -= 1
            if self.timeRemaining < 0 {
                self.timerState = .overtime
            }
        }
    }
    
    func toggleTimer() {
        if timerState == .running || timerState == .overtime {
            timerState = .paused
            timer?.invalidate()
        } else {
            timerState = timeRemaining >= 0 ? .running : .overtime
            startTimer()
        }
    }
    
    // 완료 버튼 로직(inProgress 상태에서 completed로 변경)
    func markTaskAsCompleted() {
        guard let currentIndex = routineItem.taskList.firstIndex(where: { !$0.isCompleted }) else {
            isRoutineCompleted = true
            timer?.invalidate()
            return
        }
        
        routineItem.taskList[currentIndex].isCompleted = true
        
        if let nextTask = routineItem.taskList.dropFirst(currentIndex + 1).first(where: { !$0.isCompleted }) {
            timeRemaining = nextTask.timer
        } else {
            isRoutineCompleted = true
            timer?.invalidate()
        }
    }
    
    // 스킵 버튼 로직(inProgress 상태에서 pending으로 변경)
    func skipTask() {
        guard let currentIndex = routineItem.taskList.firstIndex(where: { !$0.isCompleted }) else {
            isRoutineCompleted = true
            timer?.invalidate()
            return
        }
                
        if let nextTask = routineItem.taskList.dropFirst(currentIndex + 1).first(where: { !$0.isCompleted }) {
            timeRemaining = nextTask.timer
        } else {
            isRoutineCompleted = true
            timer?.invalidate()
        }
    }
    
    func resetTask() {
        if routineItem.taskList.filter({!$0.isCompleted}).isEmpty && !routineItem.taskList.isEmpty { // 모든일이 완료되었다면 초기화 시켜준다.
            for task in routineItem.taskList {
                task.isCompleted = false
            }
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
