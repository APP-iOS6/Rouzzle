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
                documentId: "routine1_20241113",
                routineId: "routine1",
                userId: "user1",
                date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                taskCompletions: [
                    TaskCompletion(
                        title: TaskList.sampleData[0].title,
                        emoji: TaskList.sampleData[0].emoji,
                        timer: TaskList.sampleData[0].timer,
                        isComplete: true
                    ),
                    TaskCompletion(
                        title: TaskList.sampleData[0].title,
                        emoji: TaskList.sampleData[0].emoji,
                        timer: TaskList.sampleData[0].timer,
                        isComplete: false
                    ),
                    TaskCompletion(
                        title: TaskList.sampleData[0].title,
                        emoji: TaskList.sampleData[0].emoji,
                        timer: TaskList.sampleData[0].timer,
                        isComplete: false
                    ),
                    TaskCompletion(
                        title: TaskList.sampleData[0].title,
                        emoji: TaskList.sampleData[0].emoji,
                        timer: TaskList.sampleData[0].timer,
                        isComplete: true
                    ),
                    TaskCompletion(
                        title: TaskList.sampleData[1].title,
                        emoji: TaskList.sampleData[1].emoji,
                        timer: TaskList.sampleData[1].timer,
                        isComplete: true
                    )
                ]
            )
        ]
        updateFromRoutineCompletions(dummyCompletions)
    }
}
