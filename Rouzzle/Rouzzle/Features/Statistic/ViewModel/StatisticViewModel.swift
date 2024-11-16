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
        // 테스트용 랜덤값 - 각 루틴별로 다른 값을 반환하도록 설정
        if let index = routines.firstIndex(where: { $0.id == routine.id }) {
            switch index {
            case 0:
                return Int.random(in: 70...80)
            case 1:
                return Int.random(in: 50...60)
            case 2:
                return Int.random(in: 60...70)
            case 3:
                return Int.random(in: 40...50)
            default:
                return Int.random(in: 90...100)
            }
        }
        return Int.random(in: 48...52)
    }
    
    /* 일단 UI 확인용 테스트 값 설정 나중에 주석 풀고 확인
        let calendar = Calendar.current
        
        // 현재 달의 시작일과 마지막일 구하기
        guard let interval = calendar.dateInterval(of: .month, for: calendarViewModel.currentDate)
        else { return 0 }
        
        let startOfMonth = interval.start
        let endOfMonth = interval.end
        
        // 해당 루틴의 요일에 해당하는 날짜만 필터링
        let routineDays = routine.dayStartTime.keys
        var totalRoutineDays = 0
        var completedDays = 0
        
        // 달의 모든 날짜를 순회하며 체크
        var currentDay = startOfMonth
        while currentDay < endOfMonth {
            let weekday = calendar.component(.weekday, from: currentDay)
            
            if routineDays.contains(weekday) {
                totalRoutineDays += 1
                
                // 완료 여부 확인
                if let status = taskManager.getTaskStatus(for: currentDay),
                   status == .fullyComplete {
                    completedDays += 1
                }
            }
            
            currentDay = calendar.date(byAdding: .day, value: 1, to: currentDay) ?? endOfMonth
        }
        
        // 성공률 계산
        return totalRoutineDays > 0 ? Int((Double(completedDays) / Double(totalRoutineDays)) * 100) : 0
    }
    */
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
