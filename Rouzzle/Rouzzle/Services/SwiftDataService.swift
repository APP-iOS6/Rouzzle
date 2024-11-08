//
//  SwiftDataService.swift
//  Rouzzle
//
//  Created by 김정원 on 11/8/24.
//

import Foundation
import SwiftData

enum SwiftDataService {
    // 루틴 관련 메서드
    static func addRoutine(title: String, emoji: String, dayStartTime: [Int: Date], context: ModelContext) throws {
        guard !title.isEmpty else {
            throw SwiftDataServiceError.invalidInput("루틴 제목이 비어 있습니다.")
        }
        let newRoutineItem = RoutineItem(title: title, emoji: emoji, dayStartTime: [1: .now])
        context.insert(newRoutineItem)
        do {
            try context.save()
        } catch {
            throw SwiftDataServiceError.saveFailed(error)
        }
    }
    static func deleteRoutine(routine: RoutineItem, context: ModelContext) throws {
        context.delete(routine)
        do {
            try context.save()
        } catch {
            throw SwiftDataServiceError.deleteFailed(error)
        }
    }

    // 할 일 관련 메서드
    static func addTask(to routineItem: RoutineItem, title: String, emoji: String, timer: Int?, context: ModelContext) throws {
        let newTask = TaskList(
            title: title,
            emoji: emoji
        )
        context.insert(newTask)
        try context.save()
    }

    static func deleteTask(task: TaskList, context: ModelContext) throws {
        context.delete(task)
        try context.save()
    }
}
