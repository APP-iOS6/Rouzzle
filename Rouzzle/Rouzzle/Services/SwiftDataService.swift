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
    @MainActor
    static func addRoutine(_ routine: RoutineItem, context: ModelContext) throws {
        context.insert(routine)
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
    static func addTask(to routineItem: RoutineItem, _ task: TaskList, context: ModelContext) throws {
        task.routineItem = routineItem
        routineItem.taskList.append(task)
        context.insert(task)
        do {
            try context.save()
        } catch {
            throw SwiftDataServiceError.saveFailed(error)
        }
    }

    static func deleteTask(from routineItem: RoutineItem, task: TaskList, context: ModelContext) throws {
        if let index = routineItem.taskList.firstIndex(where: { $0.id == task.id }) {
            routineItem.taskList.remove(at: index)
        }
        context.delete(task)
        
        do {
            try context.save()
        } catch {
            throw SwiftDataServiceError.deleteFailed(error)
        }
    }
}
