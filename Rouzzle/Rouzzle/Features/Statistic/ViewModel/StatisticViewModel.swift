//
//  StatisticViewModel.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/13/24.
//

import Foundation
import Factory

@Observable
class StatisticViewModel {
    @ObservationIgnored
    @Injected(\.routineService) private var routineService
    
    var routines: [RoutineItem] = []
    var currentDate: Date
    var taskManager: CalendarTaskManager
    var calendarViewModel: CalendarViewModel
    
    init(currentDate: Date = Date(), taskManager: CalendarTaskManager = CalendarTaskManager()) {
        self.currentDate = currentDate
        self.taskManager = taskManager
        self.calendarViewModel = CalendarViewModel(
            currentDate: currentDate,
            taskManager: taskManager
        )
        
        // 루틴 데이터 로드
        loadRoutines()
    }
    func loadRoutines() {
        Task {
            do {
                let fetchedRoutines = try await routineService.getAllRoutines()
                await MainActor.run {
                    self.routines = fetchedRoutines.map { RoutineItem(from: $0) }
                }
            } catch {
                print("루틴 데이터 로딩 실패: \(error)")
            }
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
