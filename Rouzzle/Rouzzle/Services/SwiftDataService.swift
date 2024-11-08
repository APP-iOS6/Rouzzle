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
    static func addTask(_ task: TaskList, context: ModelContext) throws {
        context.insert(task)
        try context.save()
    }

    static func deleteTask(task: TaskList, context: ModelContext) throws {
        context.delete(task)
        try context.save()
    }
    
    // 새로운 메서드: 루틴의 할 일을 함께 추가
     static func addRoutineWithTasks(_ routine: RoutineItem, tasks: [TaskList], context: ModelContext) throws {
         // Establish relationships
         routine.taskList = tasks
         for task in tasks {
             task.routineItem = routine
             context.insert(task)
         }
         do {
             try context.save()
         } catch {
             throw SwiftDataServiceError.saveFailed(error)
         }
     }
    
}
