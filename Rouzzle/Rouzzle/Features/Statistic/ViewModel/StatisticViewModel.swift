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
    private var observer: Any?  // NSObject에서 Any로 변경
    
    init(currentDate: Date = Date(), taskManager: CalendarTaskManager = CalendarTaskManager(), context: ModelContext) {
        self.currentDate = currentDate
        self.taskManager = taskManager
        self.calendarViewModel = CalendarViewModel(
            currentDate: currentDate,
            taskManager: taskManager
        )
        self.context = context
        
        Task { @MainActor in  // init에서 MainActor로 실행
            loadLocalRoutines()
        }
        setupObserver()
    }
    
    private func setupObserver() {
       NotificationCenter.default.addObserver(
           forName: NSNotification.Name("RoutineItemDidChange"),
           object: nil,
           queue: .main
       ) { [weak self] _ in
           Task { @MainActor in
               self?.loadLocalRoutines()
           }
       }
    }

    // SwiftData에서 로컬 루틴 데이터 로드
    @MainActor
    func loadLocalRoutines() {
       let descriptor = FetchDescriptor<RoutineItem>()
       do {
           let localRoutines = try context.fetch(descriptor)
           self.routines = localRoutines
       } catch {
           print("로컬 루틴 데이터 로딩 실패: \(error)")
       }
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
    
    // MARK: - 차트 관련 메서드들
    func calculateSuccessRate(for routine: RoutineItem) -> Int {
        
        return Int.random(in: 30...100)
//        let calendar = Calendar.current
//
//        // 현재 달의 시작일과 마지막일 구하기
//        guard let interval = calendar.dateInterval(of: .month, for: currentDate)
//        else { return 0 }
//
//        let startOfMonth = interval.start
//        let endOfMonth = interval.end
//
//        // 해당 루틴의 요일에 해당하는 날짜만 필터링
//        let routineDays = routine.dayStartTime.keys
//        var totalRoutineDays = 0
//        var completedDays = 0
//
//        // 달의 모든 날짜를 순회하며 체크
//        var currentDay = startOfMonth
//        while currentDay < endOfMonth {
//            let weekday = calendar.component(.weekday, from: currentDay)
//
//            if routineDays.contains(weekday) {
//                totalRoutineDays += 1
//
//                // 완료 여부 확인
//                if let status = taskManager.getTaskStatus(for: currentDay),
//                   status == .fullyComplete {
//                    completedDays += 1
//                }
//            }
//
//            currentDay = calendar.date(byAdding: .day, value: 1, to: currentDay) ?? endOfMonth
//        }
//
//        // 성공률 계산
//        return totalRoutineDays > 0 ? Int((Double(completedDays) / Double(totalRoutineDays)) * 100) : 0
    }
    
    func getMaxConsecutiveDays() -> Int {
        // TODO: 최대 연속 일수 계산 로직 구현
        return 0
    }
    
    func getMaxConsecutiveRoutineName() -> String {
        return routines.first?.title ?? "없음"
    }
    
    deinit {
        // observer 정리
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
