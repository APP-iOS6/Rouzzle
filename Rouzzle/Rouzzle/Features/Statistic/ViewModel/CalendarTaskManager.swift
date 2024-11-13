//
//  CalendarTaskManager.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/13/24.
//

import SwiftUI

@Observable
// 날짜별 TaskStatus를 관리
// Firebase에서 완료 데이터를 가져오거나 저장
// 캘린더와 통합하여 UI 업데이트를 지원
class CalendarTaskManager {
    // 날짜별 완료 상태를 저장하는 딕셔너리
    var completionStatus: [String: CalendarTaskStatus] = [:]
    
    // 특정 날짜의 상태 업데이트 함수
    func updateTaskStatus(for date: Date, status: CalendarTaskStatus) {
        let dateString = date.formatted(date: .long, time: .omitted)
        completionStatus[dateString] = status
    }
    
    // 특정 날짜의 상태를 가져오는 함수
    func getTaskStatus(for date: Date) -> CalendarTaskStatus? {
        let dateString = date.formatted(date: .long, time: .omitted)
        return completionStatus[dateString]
    }
    
    // RoutineCompletion으로부터 상태 업데이트
    func updateFromRoutineCompletion(_ completion: RoutineCompletion) {
        let status = completion.isCompleted ?
        CalendarTaskStatus.fullyComplete :
        CalendarTaskStatus.partiallyComplete
        
        updateTaskStatus(for: completion.date, status: status)
    }
    
    // 여러 RoutineCompletion을 한번에 처리
    func updateFromRoutineCompletions(_ completions: [RoutineCompletion]) {
        for completion in completions {
            updateFromRoutineCompletion(completion)
        }
    }
    
    // 특정 날짜의 모든 완료 상태를 가져오는 함수
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
    
    // 여러 날짜의 완료 상태를 한번에 업데이트하는 함수
    func batchUpdateStatus(for dates: [Date], status: CalendarTaskStatus) {
        for date in dates {
            updateTaskStatus(for: date, status: status)
        }
    }
    
    // 내부 helper 메서드
    private func formatStringToDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.date(from: dateString)
    }

    /// 더미 데이터를 추가하는 함수
    func loadDummyData() {
        let dummyCompletions = [
            RoutineCompletion(
                routineId: "routine1",
                userId: "user1",
                date: Date(), // 오늘 날짜
                taskCompletions: [
                    TaskCompletion(title: "Task 1", emoji: "☕️", timer: 600, isComplete: true),
                    TaskCompletion(title: "Task 2", emoji: "📚", timer: 300, isComplete: false)
                ]
            ),
            RoutineCompletion(
                routineId: "routine2",
                userId: "user1",
                date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, // 12일
                taskCompletions: [
                    TaskCompletion(title: "Task 3", emoji: "✅", timer: 120, isComplete: true),
                    TaskCompletion(title: "Task 4", emoji: "🚶‍♂️", timer: 900, isComplete: false)
                ]
            ),
            RoutineCompletion(
                routineId: "routine2",
                userId: "user1",
                date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, // 11일
                taskCompletions: [
                    TaskCompletion(title: "Task 3", emoji: "✅", timer: 120, isComplete: true),
                    TaskCompletion(title: "Task 4", emoji: "🚶‍♂️", timer: 900, isComplete: true)
                ]
            ),
            RoutineCompletion(
                routineId: "routine2",
                userId: "user1",
                date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, // 10일
                taskCompletions: [
                    TaskCompletion(title: "Task 3", emoji: "✅", timer: 120, isComplete: true),
                    TaskCompletion(title: "Task 4", emoji: "🚶‍♂️", timer: 900, isComplete: true)
                ]
            ),
            RoutineCompletion(
                routineId: "routine2",
                userId: "user1",
                date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, // 9일
                taskCompletions: [
                    TaskCompletion(title: "Task 3", emoji: "✅", timer: 120, isComplete: true),
                    TaskCompletion(title: "Task 4", emoji: "🚶‍♂️", timer: 900, isComplete: false)
                ]
            ),
            RoutineCompletion(
                routineId: "routine2",
                userId: "user1",
                date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, // 8일
                taskCompletions: [
                    TaskCompletion(title: "Task 3", emoji: "✅", timer: 120, isComplete: true),
                    TaskCompletion(title: "Task 4", emoji: "🚶‍♂️", timer: 900, isComplete: true)
                ]
            ),
            RoutineCompletion(
                routineId: "routine2",
                userId: "user1",
                date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, // 7일
                taskCompletions: [
                    TaskCompletion(title: "Task 3", emoji: "✅", timer: 120, isComplete: true),
                    TaskCompletion(title: "Task 4", emoji: "🚶‍♂️", timer: 900, isComplete: true)
                ]
            ),
            RoutineCompletion(
                routineId: "routine2",
                userId: "user1",
                date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, // 6일
                taskCompletions: [
                    TaskCompletion(title: "Task 3", emoji: "✅", timer: 120, isComplete: true),
                    TaskCompletion(title: "Task 4", emoji: "🚶‍♂️", timer: 900, isComplete: true)
                ]
            ),
            RoutineCompletion(
                routineId: "routine2",
                userId: "user1",
                date: Calendar.current.date(byAdding: .day, value: -8, to: Date())!, // 5일
                taskCompletions: [
                    TaskCompletion(title: "Task 3", emoji: "✅", timer: 120, isComplete: true),
                    TaskCompletion(title: "Task 4", emoji: "🚶‍♂️", timer: 900, isComplete: true)
                ]
            ),
            RoutineCompletion(
                routineId: "routine2",
                userId: "user1",
                date: Calendar.current.date(byAdding: .day, value: -9, to: Date())!, // 4일
                taskCompletions: [
                    TaskCompletion(title: "Task 3", emoji: "✅", timer: 120, isComplete: true),
                    TaskCompletion(title: "Task 4", emoji: "🚶‍♂️", timer: 900, isComplete: false)
                ]
            ),
            RoutineCompletion(
                routineId: "routine2",
                userId: "user1",
                date: Calendar.current.date(byAdding: .day, value: -10, to: Date())!, // 3일
                taskCompletions: [
                    TaskCompletion(title: "Task 3", emoji: "✅", timer: 120, isComplete: true),
                    TaskCompletion(title: "Task 4", emoji: "🚶‍♂️", timer: 900, isComplete: true)
                ]
            ),
            RoutineCompletion(
                routineId: "routine2",
                userId: "user1",
                date: Calendar.current.date(byAdding: .day, value: -11, to: Date())!, // 2일
                taskCompletions: [
                    TaskCompletion(title: "Task 3", emoji: "✅", timer: 120, isComplete: true),
                    TaskCompletion(title: "Task 4", emoji: "🚶‍♂️", timer: 900, isComplete: false)
                ]
            ),
            RoutineCompletion(
                routineId: "routine2",
                userId: "user1",
                date: Calendar.current.date(byAdding: .day, value: -12, to: Date())!, // 1일
                taskCompletions: [
                    TaskCompletion(title: "Task 3", emoji: "✅", timer: 120, isComplete: true),
                    TaskCompletion(title: "Task 4", emoji: "🚶‍♂️", timer: 900, isComplete: true)
                ]
            ),
            RoutineCompletion(
                routineId: "routine2",
                userId: "user1",
                date: Calendar.current.date(byAdding: .day, value: -13, to: Date())!, // 31일
                taskCompletions: [
                    TaskCompletion(title: "Task 3", emoji: "✅", timer: 120, isComplete: true),
                    TaskCompletion(title: "Task 4", emoji: "🚶‍♂️", timer: 900, isComplete: true)
                ]
            ),
            RoutineCompletion(
                routineId: "routine2",
                userId: "user1",
                date: Calendar.current.date(byAdding: .day, value: -14, to: Date())!, // 30일
                taskCompletions: [
                    TaskCompletion(title: "Task 3", emoji: "✅", timer: 120, isComplete: true),
                    TaskCompletion(title: "Task 4", emoji: "🚶‍♂️", timer: 900, isComplete: true)
                ]
            )
        ]
        updateFromRoutineCompletions(dummyCompletions)
    }
}
