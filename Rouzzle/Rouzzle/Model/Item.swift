//
//  Item.swift
//  Rouzzle
//
//  Created by 김정원 on 11/8/24.
//

import Foundation
import SwiftData

@Model
class RoutineItem: Identifiable {
    var id: UUID = UUID()
    var documentId: String = ""
    var title: String
    var emoji: String
    var repeatCount: Int?
    var interval: Int?
    var dayStartTime: [Int: Date]
    var alarmIDs: [Int: String]?

    @Relationship(deleteRule: .cascade)
    var taskList: [TaskList] = []

    init(
        documentId: String = "",
        title: String,
        emoji: String,
        dayStartTime: [Int: Date],
        repeatCount: Int? = nil,
        interval: Int? = nil,
        alarmIDs: [Int: String]? = nil
    ) {
        self.documentId = documentId
        self.title = title
        self.emoji = emoji
        self.dayStartTime = dayStartTime
        self.repeatCount = repeatCount
        self.interval = interval
        self.alarmIDs = alarmIDs
    }
}

@Model
class TaskList: Identifiable {
    var id = UUID()
    var title: String
    var emoji: String
    var timer: Int
    var isCompleted: Bool = false

    @Relationship(inverse: \RoutineItem.taskList)
    var routineItem: RoutineItem?

    init(
        title: String,
        emoji: String,
        timer: Int
    ) {
        self.title = title
        self.emoji = emoji
        self.timer = timer
    }
}
