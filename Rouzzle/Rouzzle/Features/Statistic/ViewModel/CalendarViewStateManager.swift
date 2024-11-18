//
//  CalendarViewStateManager.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/17/24.
//

import SwiftUI
import Factory

@Observable
final class CalendarViewStateManager {
    static let shared = CalendarViewStateManager()
    
    var currentDate: Date
    var currentMonth: Int = 0
    var days: [DateValue] = []
    let taskManager: CalendarTaskManager
    var isLoading: Bool = false
    
    @ObservationIgnored
    @Injected(\.routineService) private var routineService
    
    let koreanDays = ["월", "화", "수", "목", "금", "토", "일"]
    
    private init() {
        self.currentDate = Date()
        self.taskManager = CalendarTaskManager()
        extractDate()
        loadDummyData()
    }
    
    // 현재 월로 초기화
    func resetToCurrentMonth() {
        currentMonth = 0
        currentDate = Date()
        extractDate()
        Task {
            await loadRoutineCompletions()
        }
    }
    
    @MainActor
    func moveMonth(direction: Int) async {
        guard !isLoading else { return }
        isLoading = true
        
        currentMonth += direction
        
        let calendar = Calendar.current
        if let newDate = calendar.date(byAdding: .month, value: currentMonth, to: Date()) {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentDate = newDate
                extractDate()
            }
            await loadRoutineCompletions()
        }
        
        isLoading = false
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
    
    @MainActor
    func loadRoutineCompletions() async {
        let result = await routineService.getRoutineCompletions(for: currentDate)
        if case .success(let completions) = result {
            withAnimation(.easeInOut(duration: 0.3)) {
                taskManager.updateFromRoutineCompletions(completions)
            }
        }
    }
    
    func loadDummyData() {
        taskManager.loadDummyData()
    }
}
