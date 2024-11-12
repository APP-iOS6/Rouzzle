//
//  RoutineEditData.swift
//  Rouzzle
//
//  Created by 김동경 on 11/12/24.
//

import Foundation

struct RoutineEditData: Hashable {
    var id: String
    var title: String
    var emoji: String
    var repeatCount: Int?
    var interval: Int?
    var dayStartTime: [Int: String]
    var alarmIDs: [Int: String]?
    var userId: String
    var taskList: [TaskEditData]
    
    func toRoutineItem() -> RoutineItem {
        return RoutineItem(
            id: id,
            title: title,
            emoji: emoji,
            dayStartTime: dayStartTime,
            repeatCount: repeatCount,
            interval: interval,
            alarmIDs: alarmIDs,
            userId: userId
        )
    }
}

struct TaskEditData: Identifiable, Hashable {
    var id: UUID
    var title: String
    var emoji: String
    var timer: Int
    var isCompleted: Bool
    
    func toTaskList() -> TaskList {
        return TaskList(
            id: id,
            title: title,
            emoji: emoji,
            timer: timer,
            isCompleted: isCompleted
        )
    }
}
