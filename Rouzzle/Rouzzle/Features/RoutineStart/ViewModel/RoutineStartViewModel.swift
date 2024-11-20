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
    
    // 기존 computed properties 유지
    var inProgressTask: TaskList? {
        viewTasks.first { !$0.isCompleted }
    }
    
    var nextPendingTask: TaskList? {
        viewTasks
            .drop(while: { $0.isCompleted })
            .dropFirst()
            .first(where: { !$0.isCompleted })
    }
    
    var isRoutineCompleted = false // 모든 작업 완료 여부 체크
    private var isResuming = false // 일시정지 후 재개 상태를 추적
    
    // taskManager 파라미터 추가
    init(routineItem: RoutineItem) {
        print("뷰모델 생성")
        self.routineItem = routineItem
        self.viewTasks = routineItem.taskList
    }
    // 타이머 시작
    func startTimer() {
        if !isResuming {
            self.timeRemaining = inProgressTask?.timer ?? 0
        }
        isResuming = false // 설정 후 초기화
        
        timer?.invalidate()
        
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
        if timerState == .running || timerState == .overtime {
            timerState = .paused
            timer?.invalidate()
        } else {
            timerState = timeRemaining >= 0 ? .running : .overtime
            isResuming = true
            startTimer()
        }
    }
    
    // 완료 버튼 로직 수정 - 루틴 완료 시 Firebase 저장 및 캘린더 업데이트 추가
    func markTaskAsCompleted() {
        guard let currentIndex = viewTasks.firstIndex(where: { !$0.isCompleted }) else {
            isRoutineCompleted = true
            timer?.invalidate()
            return
        }
        
        viewTasks[currentIndex].isCompleted = true
        
        if let modelIndex = routineItem.taskList.firstIndex(where: { $0.id == viewTasks[currentIndex].id }) {
            routineItem.taskList[modelIndex].isCompleted = true
        }
        
        if let nextTask = viewTasks.dropFirst(currentIndex + 1).first(where: { !$0.isCompleted }) {
            print("담작겁이승ㅁ")
            timeRemaining = nextTask.timer
            timerState = .running
            startTimer()
        } else {
            isRoutineCompleted = true
            timer?.invalidate()
        }
    }
    
    // 스킵 버튼 로직(inProgress 상태에서 pending으로 변경)
    func skipTask() {
        guard let currentIndex = viewTasks.firstIndex(where: { !$0.isCompleted }) else {
            isRoutineCompleted = true
            timer?.invalidate()
            return
        }
        
        // 현재 작업을 건너뛰고 다음 작업으로 이동
        if let nextTask = viewTasks.dropFirst(currentIndex + 1).first(where: { !$0.isCompleted }) {
            timeRemaining = nextTask.timer
            timerState = .running
            startTimer()
        } else {
            isRoutineCompleted = true
            timer?.invalidate()
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
