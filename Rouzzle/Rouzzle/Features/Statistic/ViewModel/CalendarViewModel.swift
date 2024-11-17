//
//  CalendarViewModel.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/13/24.
//

import Foundation
import Factory
import SwiftUI

@Observable
class CalendarViewModel {
    private var taskManager: CalendarTaskManager
    @ObservationIgnored
    @Injected(\.routineService) private var routineService
    
    var currentDate: Date
    var currentMonth: Int = 0
    var days: [DateValue] = []
    
    let koreanDays = ["월", "화", "수", "목", "금", "토", "일"]
    
    init(currentDate: Date = Date(), taskManager: CalendarTaskManager) {
        self.currentDate = currentDate
        self.taskManager = taskManager
        extractDate()
        loadDummyData()
    }
    
    func moveMonth(direction: Int) {
        currentMonth += direction
        extractDate()
    }
    
    func getDayColor(for index: Int) -> Color {
        switch index {
        case 6: return .red
        case 5: return .blue
        default: return .primary
        }
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func getTaskStatus(for date: Date) -> CalendarTaskStatus? {
        return taskManager.getTaskStatus(for: date)
    }
    
    func extractDate() {
        let calendar = Calendar.current
        let month = calendar.date(byAdding: .month, value: currentMonth, to: Date())!
        
        currentDate = month
        var days = getMonthDates(for: month)
        
        let firstWeekday = (calendar.component(.weekday, from: days.first?.date ?? Date()) + 5) % 7
        for _ in 0..<firstWeekday {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        self.days = days
    }
    
    private func getMonthDates(for date: Date) -> [DateValue] {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        var days: [DateValue] = []
        let firstDay = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
        let range = calendar.range(of: .day, in: .month, for: firstDay)!
        
        for day in range {
            let date = calendar.date(from: DateComponents(year: year, month: month, day: day))!
            days.append(DateValue(day: day, date: date))
        }
        
        return days
    }
    
    func extraData() -> [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        
        formatter.dateFormat = "MM"
        let month = formatter.string(from: currentDate)
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: currentDate)
        
        return [month, year]
    }
    
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
}
