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
import SwiftData
import FirebaseFirestore

@Observable
class RoutineStartStore {
    
    @ObservationIgnored
    @Injected(\.routineService) private var routineService
    
    private var timer: Timer?
    var routineStore: RoutineStore
    var timerState: TimerState = .running
    var timeRemaining: Int = 0
    var routineItem: RoutineItem = RoutineItem.sampleData[0]
    var viewTasks: [TaskList] = []
    var currentTaskIndex: Int = 0
    var isRoutineCompleted = false // 모든 작업 완료 여부 체크
    var isAllCompleted = false
    private var isResuming = false // 일시정지 후 재개 상태를 추적
    var routineTakeTime: (Date?, Date?)
    private var startTime: Date?
    private var endTime: Date?

    var inProgressTask: TaskList? {
        if viewTasks.isEmpty || isRoutineCompleted {
            return nil
        }
        return viewTasks[currentTaskIndex]
    }
    
    var nextPendingTask: TaskList? {
        let totalTasks = viewTasks.count
        var nextIndex = currentTaskIndex
        var checkedTasks = 0

        while checkedTasks < totalTasks {
            nextIndex = (nextIndex + 1) % totalTasks
            checkedTasks += 1
            if !viewTasks[nextIndex].isCompleted && nextIndex != currentTaskIndex {
                return viewTasks[nextIndex]
            }
        }
        return nil
    }
    
    init(routineStore: RoutineStore) {
        print("타이머 뷰모델 생성")
        self.routineStore = routineStore
        fetchData()
    }
    
    func fetchData() {
        routineItem = routineStore.routineItem ?? RoutineItem.sampleData[0]
        viewTasks = routineStore.routineItem?.taskList ?? []
    }
    // MARK: - 타이머 관련 메서드
    
    func startTimer() {
        guard currentTaskIndex < viewTasks.count else {
            isRoutineCompleted = true
            return
        }

        if routineTakeTime.0 == nil {
            routineTakeTime.0 = Date()
        }
        
        startTime = Date()
        
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
            if self.isRoutineCompleted {
                endRoutine()
            }
        }
    }
    
    // MARK: - 루틴 종료
    func endRoutine() {
        timer?.invalidate()
        timer = nil
        routineTakeTime.1 = Date() // 종료 시간 설정
        isRoutineCompleted = true
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
    func markTaskAsCompleted(_ context: ModelContext) {
        guard currentTaskIndex < viewTasks.count else {
            endRoutine()
            return
        }
        endTime = Date()
        let elapsedTime = Int(endTime?.timeIntervalSince(startTime ?? Date()) ?? 0)
        
        viewTasks[currentTaskIndex].elapsedTime = elapsedTime

        if let modelIndex = routineItem.taskList.firstIndex(where: { $0.id == viewTasks[currentTaskIndex].id }) {
            routineItem.taskList[modelIndex].isCompleted = true
            viewTasks[currentTaskIndex].isCompleted = true
            do {
                try context.save()
                startTime = nil
                endTime = nil
            } catch {
                print("할일 완료에 실패했다구")
            }
        }
        
        timer?.invalidate()
        moveToNextIncompleteTask()
        
        if currentTaskIndex < viewTasks.count {
            timerState = .running
            startTimer()
        } else {
            endRoutine()
        }
    }
    
    // 스킵 버튼 로직(inProgress 상태에서 pending으로 변경)
    func skipTask() {
        guard !isRoutineCompleted else {
            timer?.invalidate()
            return
        }
        
        timer?.invalidate()
        moveToNextIncompleteTask()
        
        if !isRoutineCompleted {
            timerState = .running
            isResuming = false
            startTimer()
        } else {
            endRoutine()
        }
    }
    
    func resetTask() {
        print("리셋 테스크")
    
        if routineItem.taskList.filter({!$0.isCompleted}).isEmpty && !routineItem.taskList.isEmpty { // 모든일이 완료되었다면 초기화 시켜준다.
            for task in routineItem.taskList {
                task.isCompleted = false
                task.elapsedTime = nil
            }
        }
    }
    
    func moveToNextIncompleteTask() {
        var foundIncompleteTask = false
        var checkedTasks = 0
        
        while checkedTasks < viewTasks.count {
            currentTaskIndex = (currentTaskIndex + 1) % viewTasks.count
            checkedTasks += 1
            if !viewTasks[currentTaskIndex].isCompleted {
                foundIncompleteTask = true
                break
            }
        }
        
        if !foundIncompleteTask {
            endRoutine()
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
    
    @MainActor
    func startRoutine() {
        // 루틴 실행 시작 시 알림 취소 호출
        NotificationManager.shared.removeNotifications(withPrefix: routineItem.id)
        print("루틴 실행 시작됨. 알림 취소 완료.")
    }
}
