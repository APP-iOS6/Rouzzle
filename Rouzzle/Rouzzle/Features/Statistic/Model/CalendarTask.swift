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
struct DateValue: Identifiable {
    var id = UUID().uuidString    // 각 날짜를 구분하기 위한 고유 ID
    var day: Int                  // 일(1~31)
    var date: Date                // 전체 날짜 정보
}
