//
//  CalendarTaskManager.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/13/24.
//

import SwiftUI

@Observable
class CalendarTaskManager {
    var completionStatus: [String: CalendarTaskStatus] = [:]
    
    func updateTaskStatus(for date: Date, status: CalendarTaskStatus) {
        let dateString = date.formatted(date: .long, time: .omitted)
        completionStatus[dateString] = status
    }
    
    func getTaskStatus(for date: Date) -> CalendarTaskStatus? {
        let dateString = date.formatted(date: .long, time: .omitted)
        return completionStatus[dateString]
    }
    
    func updateFromRoutineCompletion(_ completion: RoutineCompletion) {
        let status = completion.isCompleted ?
            CalendarTaskStatus.fullyComplete :
            CalendarTaskStatus.partiallyComplete
        
        updateTaskStatus(for: completion.date, status: status)
    }
    
    func updateFromRoutineCompletions(_ completions: [RoutineCompletion]) {
        for completion in completions {
            updateFromRoutineCompletion(completion)
        }
    }
    
    func getCompletionStatusForDay(_ date: Date) -> [String: CalendarTaskStatus] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return completionStatus.filter { statusDate, _ in
            if let date = formatStringToDate(statusDate) {
                return date >= startOfDay && date < endOfDay
            }
            return false
        }
    }
    
    func batchUpdateStatus(for dates: [Date], status: CalendarTaskStatus) {
        for date in dates {
            updateTaskStatus(for: date, status: status)
        }
    }
    
    private func formatStringToDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.date(from: dateString)
    }
}
