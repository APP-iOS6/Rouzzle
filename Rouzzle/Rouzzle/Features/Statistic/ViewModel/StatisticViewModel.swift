//
//  StatisticViewModel.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/13/24.
//

import Factory
import Foundation
import Observation
import SwiftData

@Observable
class StatisticViewModel {
    @ObservationIgnored
    @Injected(\.routineService) private var routineService
    
    var routines: [RoutineItem] = []
    var currentDate: Date
    var taskManager: CalendarTaskManager
    var calendarViewModel: CalendarViewModel
    var context: ModelContext
    
    init(currentDate: Date = Date(), taskManager: CalendarTaskManager = CalendarTaskManager(), context: ModelContext) {
        self.currentDate = currentDate
        self.taskManager = taskManager
        self.calendarViewModel = CalendarViewModel(
            currentDate: currentDate,
            taskManager: taskManager
        )
        self.context = context
        
        loadLocalRoutines()
    }
    
    // SwiftData에서 로컬 루틴 데이터 로드
    func loadLocalRoutines() {
        let descriptor = FetchDescriptor<RoutineItem>()
        do {
            let localRoutines = try context.fetch(descriptor)
            self.routines = localRoutines
        } catch {
            print("로컬 루틴 데이터 로딩 실패: \(error)")
        }
    }
    
    // 완료된 루틴 개수 계산
    func getCompletedCount() -> Int {
        taskManager.completionStatus.values.filter { $0 == .fullyComplete }.count
    }
    
    // 부분 완료된 루틴 개수 계산
    func getPartialCount() -> Int {
        taskManager.completionStatus.values.filter { $0 == .partiallyComplete }.count
    }
    
    // 루틴 완료 데이터 로드
    func loadRoutineCompletions() {
        Task {
            let result = await routineService.getRoutineCompletions(for: currentDate)
            if case .success(let completions) = result {
                await MainActor.run {
                    taskManager.updateFromRoutineCompletions(completions)
                }
            }
        }
    }
    
    // 테스트용 더미 데이터 로드
    func loadDummyData() {
        taskManager.loadDummyData()
    }
    
    // 월별 통계 데이터 가져오기
    func getMonthlyStats() -> (completed: Int, partial: Int) {
        let completed = getCompletedCount()
        let partial = getPartialCount()
        return (completed, partial)
    }
}
