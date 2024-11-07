//
//  SwiftDataService.swift
//  Rouzzle
//
//  Created by 김정원 on 11/8/24.
//

import Foundation
import SwiftData

enum DataService {
    // 루틴 관련 메서드
    static func addRoutine(title: String, context: ModelContext) throws {
        let newRoutineItem = RoutineItem(title: title)
        context.insert(newRoutineItem)
        try context.save()
    }

    static func deleteRoutine(routine: RoutineItem, context: ModelContext) throws {
        context.delete(routine)
        try context.save()
    }

    // 할 일 관련 메서드
    static func addTask(to routineItem: RoutineItem, title: String, emoji: String, timer: Int, context: ModelContext) throws {
        let newTask = TaskList(
            title: title,
            emoji: emoji,
            timer: timer,
            isCompleted: false,
            routineItem: routineItem
        )
        context.insert(newTask)
        try context.save()
    }

    static func deleteTask(task: TaskList, context: ModelContext) throws {
        context.delete(task)
        try context.save()
    }
}
