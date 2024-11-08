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
    @Attribute(.unique) var id: String
    var title: String
    var emoji: String
    var repeatCount: Int?
    var interval: Int?
    var dayStartTime: [Int: String]
    var alarmIDs: [Int: String]?
    var userId: String
    
    @Relationship(deleteRule: .cascade)
    var taskList: [TaskList] = []
    
    init(
        id: String = "",
        title: String,
        emoji: String,
        dayStartTime: [Int: String],
        repeatCount: Int? = nil,
        interval: Int? = nil,
        alarmIDs: [Int: String]? = nil,
        userId: String = ""
    ) {
        self.id = id
        self.title = title
        self.emoji = emoji
        self.dayStartTime = dayStartTime
        self.repeatCount = repeatCount
        self.interval = interval
        self.alarmIDs = alarmIDs
        self.userId = userId
    }
    
    func toRoutine() -> Routine {
        return Routine(documentId: id, title: title, emoji: emoji, routineTask: taskList.map { $0.toRoutineTask() }, dayStartTime: dayStartTime, userId: userId)
    }
}

@Model
class TaskList: Identifiable {
    @Attribute(.unique) var id = UUID()
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
    
    func toRoutineTask() -> RoutineTask {
        return RoutineTask(title: title, emoji: emoji, timer: timer)
    }
}
