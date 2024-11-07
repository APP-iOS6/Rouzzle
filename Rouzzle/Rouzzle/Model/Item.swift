//
//  Item.swift
//  Rouzzle
//
//  Created by 김정원 on 11/8/24.
//

import Foundation
import SwiftData

@Model
final class RoutineItem: Identifiable {
    var id = UUID()
    var title: String
    var repeatCount: Int
    var interval: Int
    var dayStartTime: [Int: Date]
    var alarmIDs: [Int: String]

    @Relationship(deleteRule: .cascade)
    var taskList: [TaskList] = []

    init(
        title: String,
        taskList: [TaskList] = [],
        repeatCount: Int = 0,
        interval: Int = 0,
        dayStartTime: [Int: Date] = [:],
        alarmIDs: [Int: String] = [:]
    ) {
        self.title = title
        self.taskList = taskList
        self.repeatCount = repeatCount
        self.interval = interval
        self.dayStartTime = dayStartTime
        self.alarmIDs = alarmIDs
    }
}

@Model
final class TaskList: Identifiable {
    var id = UUID()
    var title: String // 할 일 제목
    var emoji: String // 이모지
    var timer: Int // 타이머
    var isCompleted: Bool

    @Relationship(inverse: \RoutineItem.taskList)
    var routineItem: RoutineItem?

    init(
        title: String,
        emoji: String,
        timer: Int,
        isCompleted: Bool = false,
        routineItem: RoutineItem? = nil
    ) {
        self.title = title
        self.emoji = emoji
        self.timer = timer
        self.isCompleted = isCompleted
        self.routineItem = routineItem
    }
}
