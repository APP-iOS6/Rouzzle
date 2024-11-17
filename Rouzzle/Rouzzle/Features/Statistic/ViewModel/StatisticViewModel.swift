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
    
    let routines: [RoutineItem]
    let context: ModelContext
    let calendarState: CalendarViewStateManager
    var isLoading: Bool = false
    
    init(routines: [RoutineItem], context: ModelContext) {
        print("📊 StatisticViewModel 초기화")
        self.routines = routines
        self.context = context
        self.calendarState = .shared
        
        Task {
            await loadRoutineCompletions()
        }
    }
    
    @MainActor
    func loadRoutineCompletions() async {
        guard !isLoading else { return }
        isLoading = true
        
        let result = await routineService.getRoutineCompletions(for: calendarState.currentDate)
        if case .success(let completions) = result {
            calendarState.taskManager.updateFromRoutineCompletions(completions)
        }
        
        isLoading = false
    }
    
    func calculateSuccessRate(for routine: RoutineItem) -> Int {
        let calendar = Calendar.current
        
        guard let interval = calendar.dateInterval(of: .month, for: calendarState.currentDate)
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
                
                if let status = calendarState.taskManager.getTaskStatus(for: currentDay),
                   status == .fullyComplete {
                    completedDays += 1
                }
            }
            
            currentDay = calendar.date(byAdding: .day, value: 1, to: currentDay) ?? endOfMonth
        }
        
        return totalRoutineDays > 0 ? Int((Double(completedDays) / Double(totalRoutineDays)) * 100) : 0
    }
    
    func getMaxConsecutiveDays() -> Int {
        var maxConsecutiveDays = 0
        var currentMaxRoutineId: String?
        
        for routine in routines {
            var consecutiveDays = 0
            let currentDate = Date()
            
            for dayOffset in 0..<30 {
                let checkDate = Calendar.current.date(byAdding: .day, value: -dayOffset, to: currentDate)!
                let weekday = Calendar.current.component(.weekday, from: checkDate)
                
                if routine.dayStartTime.keys.contains(weekday) {
                    if let status = calendarState.taskManager.getTaskStatus(for: checkDate),
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
    
    func getCurrentStreak(for routine: RoutineItem) -> Int {
        var streak = 0
        let calendar = Calendar.current
        var currentDate = Date()
        
        while true {
            let weekday = calendar.component(.weekday, from: currentDate)
            
            if routine.dayStartTime.keys.contains(weekday) {
                if let status = calendarState.taskManager.getTaskStatus(for: currentDate),
                   status == .fullyComplete {
                    streak += 1
                    currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? Date()
                } else {
                    break
                }
            } else {
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? Date()
            }
            
            if streak >= 30 { break }
        }
        return streak
    }
    
    func getMaxStreak(for routine: RoutineItem) -> Int {
        var maxStreak = 0
        var currentStreak = 0
        let calendar = Calendar.current
        
        for dayOffset in 0..<30 {
            let checkDate = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) ?? Date()
            let weekday = calendar.component(.weekday, from: checkDate)
            
            if routine.dayStartTime.keys.contains(weekday) {
                if let status = calendarState.taskManager.getTaskStatus(for: checkDate),
                   status == .fullyComplete {
                    currentStreak += 1
                    maxStreak = max(maxStreak, currentStreak)
                } else {
                    currentStreak = 0
                }
            }
        }
        return maxStreak
    }
    
    func getTotalCompletedDays(for routine: RoutineItem) -> Int {
        var total = 0
        let calendar = Calendar.current
        
        for dayOffset in 0..<30 {
            let checkDate = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) ?? Date()
            let weekday = calendar.component(.weekday, from: checkDate)
            
            if routine.dayStartTime.keys.contains(weekday) {
                if let status = calendarState.taskManager.getTaskStatus(for: checkDate),
                   status == .fullyComplete {
                    total += 1
                }
            }
        }
        return total
    }
}
