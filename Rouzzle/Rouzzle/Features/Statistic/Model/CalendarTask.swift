//
//  CalendarTask.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/13/24.
//

import SwiftUI

// 캘린더용 Task
struct CalendarTask: Identifiable {
    var id = UUID().uuidString
    var title: String
    var time: Date = Date()
}

// 캘린더용 TaskMetaData
struct CalendarTaskMetaData: Identifiable {
    var id = UUID().uuidString
    var task: [CalendarTask]
    var taskDate: Date
    var completionState: CalendarTaskStatus?
}

// 캘린더용 TaskStatus
enum CalendarTaskStatus {
    case fullyComplete
    case partiallyComplete
}

// 달력의 각 날짜
struct DateValue: Identifiable, Equatable, Hashable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
    
    static func == (lhs: DateValue, rhs: DateValue) -> Bool {
        return lhs.day == rhs.day && Calendar.current.isDate(lhs.date, inSameDayAs: rhs.date)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(day)
        hasher.combine(date)
    }
}
