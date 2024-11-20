//
//  RoutineStartViewModel.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/5/24.
//

import Factory
import Foundation
import Observation
import SwiftUI
import FirebaseFirestore

@Observable
class RoutineStartViewModel {
    
    @ObservationIgnored
    @Injected(\.routineService) private var routineService

    private var timer: Timer?
    var timerState: TimerState = .running
    var timeRemaining: Int = 0
    var routineItem: RoutineItem
    var viewTasks: [TaskList]
    var currentTaskIndex: Int = 0
    var isRoutineCompleted = false // 모든 작업 완료 여부 체크
    private var isResuming = false // 일시정지 후 재개 상태를 추적
    
    // 기존 computed properties 유지
    var inProgressTask: TaskList? {
        if currentTaskIndex < viewTasks.count {
            return viewTasks[currentTaskIndex]
        } else {
            return nil
        }
    }
    
    var nextPendingTask: TaskList? {
        let nextIndex = currentTaskIndex + 1
        if nextIndex < viewTasks.count {
            return viewTasks[nextIndex]
        } else {
            return nil
        }
    }
    
    init(routineItem: RoutineItem) {
        print("타이머 뷰모델 생성")
        self.routineItem = routineItem
        self.viewTasks = routineItem.taskList
    }
    // MARK: - 타이머 관련 메서드
    func startTimer() {
        guard currentTaskIndex < viewTasks.count else {
            isRoutineCompleted = true
            return
        }

        let currentTask = viewTasks[currentTaskIndex]

        if !isResuming {
            self.timeRemaining = currentTask.timer
        }
        isResuming = false

        guard timerState == .running || timerState == .overtime else { return }

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            print("Timer: \(self.timeRemaining)")
            self.timeRemaining -= 1
            if self.timeRemaining < 0 {
                self.timerState = .overtime
            }
        }
    }
    
    func toggleTimer() {
        // 일시정지 관련
        if timerState == .running || timerState == .overtime {
            timerState = .paused
            timer?.invalidate()
        } else {
            timerState = timeRemaining >= 0 ? .running : .overtime
            isResuming = true
            startTimer()
        }
    }
    
    // MARK: - 테스크 관리 메서드
    func markTaskAsCompleted() {
        guard currentTaskIndex < viewTasks.count else {
            isRoutineCompleted = true
            timer?.invalidate()
            return
        }
        
        let currentTask = viewTasks[currentTaskIndex]
        currentTask.isCompleted = true
        if let modelIndex = routineItem.taskList.firstIndex(where: { $0.id == currentTask.id }) {
            routineItem.taskList[modelIndex].isCompleted = true
            viewTasks[currentTaskIndex].isCompleted = true
        }
        
        timer?.invalidate()
        currentTaskIndex += 1
        
        if currentTaskIndex < viewTasks.count {
            timerState = .running
            startTimer()
        } else {
            initializeCurrentTaskIndex()
            if currentTaskIndex == viewTasks.count {
                isRoutineCompleted = true
            }
        }
    }
    
    // 스킵 버튼 로직(inProgress 상태에서 pending으로 변경)
    func skipTask() {
        guard currentTaskIndex < viewTasks.count else {
            isRoutineCompleted = true
            timer?.invalidate()
            return
        }
        
        timer?.invalidate()
        currentTaskIndex += 1

        // 현재 작업을 건너뛰고 다음 작업으로 이동
        if currentTaskIndex < viewTasks.count {
            timerState = .running
            isResuming = false
            startTimer()
        } else {
            initializeCurrentTaskIndex()
        }
    }
    
    func resetTask() {
        print("리셋 테스크")
    
        if routineItem.taskList.filter({!$0.isCompleted}).isEmpty && !routineItem.taskList.isEmpty { // 모든일이 완료되었다면 초기화 시켜준다.
            for task in routineItem.taskList {
                task.isCompleted = false
            }
        }
    }
    
    func initializeCurrentTaskIndex() {
        if let index = viewTasks.firstIndex(where: { !$0.isCompleted }) {
            currentTaskIndex = index
            return
        }
        isRoutineCompleted = true
    }
    
    // MARK: - 저장 관련 메서드
    func saveRoutineCompletion() async {
        let routine = routineItem.toRoutineCompletion(Date())
        _ = await updateRoutineCompletion(routine)
    }
    
    // 순서 변경 함수 (뷰 전용)
    func moveTask(from source: IndexSet, to destination: Int) {
        viewTasks.move(fromOffsets: source, toOffset: destination)
    }
    
    func updateRoutineCompletion(_ routineCompletion: RoutineCompletion) async -> Result<Void, DBError> {
        let db = Firestore.firestore()
        do {
            let routineCompletionEcode = try Firestore.Encoder().encode(routineCompletion)
            try await db.collection("RoutineCompletion").document(routineCompletion.documentId ?? UUID().uuidString).setData(routineCompletionEcode, merge: true)
            return .success(())
        } catch {
            return .failure(DBError.firebaseError(error))
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
