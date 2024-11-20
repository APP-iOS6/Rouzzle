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
        return Routine(
            documentId: id,
            title: title,
            emoji: emoji,
            routineTask: taskList.map { $0.toRoutineTask() },
            repeatCount: repeatCount,
            interval: interval,
            dayStartTime: dayStartTime,
            alarmIDs: alarmIDs,
            userId: userId
        )
    }
    
    func toRoutineEditData() -> RoutineEditData {
        return RoutineEditData(
            id: id,
            title: title,
            emoji: emoji,
            repeatCount: repeatCount,
            interval: interval,
            dayStartTime: dayStartTime,
            alarmIDs: alarmIDs,
            userId: userId,
            taskList: taskList.map { $0.toTaskEditData() }
        )
    }
    
    func toRoutineCompletion(_ date: Date) -> RoutineCompletion {
        let documentId: String = "\(date.formattedDateToString)_\(id)"
        print(documentId)
        return RoutineCompletion(
            documentId: documentId,
            routineId: id,
            userId: userId,
            date: date,
            taskCompletions: taskList.map { $0.toTaskCompletion() }
        )
    }
    
    convenience init(from routine: Routine) {
        self.init(
            id: routine.documentId ?? UUID().uuidString,
            title: routine.title,
            emoji: routine.emoji,
            dayStartTime: routine.dayStartTime,
            repeatCount: routine.repeatCount,
            interval: routine.interval,
            alarmIDs: routine.alarmIDs,
            userId: routine.userId
        )
        self.taskList = routine.routineTask.map { TaskList(from: $0) }
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
        id: UUID = UUID(),
        title: String,
        emoji: String,
        timer: Int,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.emoji = emoji
        self.timer = timer
        self.isCompleted = isCompleted
    }
    
    func toRoutineTask() -> RoutineTask {
        return RoutineTask(
            title: title,
            emoji: emoji,
            timer: timer
        )
    }
    
    func toTaskEditData() -> TaskEditData {
        return TaskEditData(
            id: id,
            title: title,
            emoji: emoji,
            timer: timer,
            isCompleted: isCompleted
        )
    }
    
    func toTaskCompletion() -> TaskCompletion {
        return TaskCompletion(
            title: title,
            emoji: emoji,
            timer: timer,
            isComplete: isCompleted
        )
    }
    
    convenience init(from routineTask: RoutineTask) {
        self.init(
            title: routineTask.title,
            emoji: routineTask.emoji,
            timer: routineTask.timer,
            isCompleted: false
        )
    }
}

extension RoutineItem {
    static let sampleData: [RoutineItem] = [
        RoutineItem(title: "아침 루틴", emoji: "🚬", dayStartTime: [1: "06:30"]),
        RoutineItem(title: "저녁 루틴", emoji: "🍺", dayStartTime: [1: "12:00"]),
        RoutineItem(title: "운동 루틴", emoji: "💪🏼", dayStartTime: [1: "18:00"])
    ]
}

extension TaskList {
    static let sampleData: [TaskList] = [
        TaskList(title: "밥 먹기", emoji: "🍚", timer: 3, isCompleted: false),
        TaskList(title: "양치 하기", emoji: "🪥", timer: 3, isCompleted: false),
        TaskList(title: "술 마시기", emoji: "🍺", timer: 30, isCompleted: false)
    ]
}
