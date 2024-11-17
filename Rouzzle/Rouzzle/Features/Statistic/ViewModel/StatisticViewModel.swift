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
    
    var routines: [RoutineItem]
    var currentDate: Date
    var taskManager: CalendarTaskManager
    var calendarViewModel: CalendarViewModel
    var context: ModelContext
    
    init(routines: [RoutineItem], currentDate: Date = Date(), taskManager: CalendarTaskManager = CalendarTaskManager(), context: ModelContext) {
        self.routines = routines
        self.currentDate = currentDate
        self.taskManager = taskManager
        self.calendarViewModel = CalendarViewModel(
            currentDate: currentDate,
            taskManager: taskManager
        )
        self.context = context
        
        // 초기 통계 데이터 로드
        loadRoutineCompletions()
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
    
    // MARK: - 차트 관련 메서드들
    // 월간 성공률 계산
    func calculateSuccessRate(for routine: RoutineItem) -> Int {
        // 테스트용 랜덤값
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
    
    /* 위에는 그래프 확인용 테스트 값 설정 나중에 주석 풀고 확인 해봐야 함
     let calendar = Calendar.current
     
     guard let interval = calendar.dateInterval(of: .month, for: calendarViewModel.currentDate)
     else { return 0 }
     
     let startOfMonth = interval.start
     let endOfMonth = interval.end
     
     let routineDays = routine.dayStartTime.keys
     var totalRoutineDays = 0
     var completedDays = 0
     
     var currentDay = startOfMonth
     while currentDay < endOfMonth {
         let weekday = calendar.component(.weekday, from: currentDay)
         
         if routineDays.contains(weekday) {
             totalRoutineDays += 1
             
             if let status = taskManager.getTaskStatus(for: currentDay),
                status == .fullyComplete {
                 completedDays += 1
             }
         }
         
         currentDay = calendar.date(byAdding: .day, value: 1, to: currentDay) ?? endOfMonth
     }
     
     return totalRoutineDays > 0 ? Int((Double(completedDays) / Double(totalRoutineDays)) * 100) : 0
 }
     */
    
    // 최대 연속일 계산
    func getMaxConsecutiveDays() -> Int {
        var maxConsecutiveDays = 0
        var currentMaxRoutineId: String?
        
        for routine in routines {
            var consecutiveDays = 0
            let currentDate = Date()
            
            // 최대 30일 전까지 체크
            for dayOffset in 0..<30 {
                let checkDate = Calendar.current.date(byAdding: .day, value: -dayOffset, to: currentDate)!
                let weekday = Calendar.current.component(.weekday, from: checkDate)
                
                if routine.dayStartTime.keys.contains(weekday) {
                    if let status = taskManager.getTaskStatus(for: checkDate),
                       status == .fullyComplete {
                        consecutiveDays += 1
                    } else {
                        break
                    }
                }
            }
            
            if consecutiveDays > maxConsecutiveDays {
                maxConsecutiveDays = consecutiveDays
                currentMaxRoutineId = routine.id
            }
        }
        
        if let maxRoutineId = currentMaxRoutineId {
            UserDefaults.standard.set(maxRoutineId, forKey: "MaxConsecutiveRoutineId")
        }
        
        return maxConsecutiveDays
    }
    
    func getMaxConsecutiveRoutineName() -> String {
        guard let maxRoutineId = UserDefaults.standard.string(forKey: "MaxConsecutiveRoutineId"),
              let routine = routines.first(where: { $0.id == maxRoutineId }) else {
            return "없음"
        }
        return routine.title
    }
}
