//
//  SwiftDataService.swift
//  Rouzzle
//
//  Created by 김정원 on 11/8/24.
//

import Foundation
import SwiftData
import SwiftUI

enum SwiftDataService {
    /// 루틴 추가 관련
    @MainActor
    static func addRoutine(_ routine: RoutineItem, context: ModelContext) throws {
        context.insert(routine)
        do {
            try context.save()
        } catch {
            throw SwiftDataServiceError.saveFailed(error)
        }
    }
    
    /// 루틴 삭제 관련
    static func deleteRoutine(routine: RoutineItem, context: ModelContext) throws {
        context.delete(routine)
        do {
            try context.save()
        } catch {
            throw SwiftDataServiceError.deleteFailed(error)
        }
    }

    /// 할 일 관련 추가
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

    /// 개별 할 일 삭제
    static func deleteTask(from routineItem: RoutineItem, task: TaskList, context: ModelContext) throws {
        if let index = routineItem.taskList.firstIndex(of: task) {
            routineItem.taskList.remove(at: index)
        }
        context.delete(task)
        // 변경사항 저장
        do {
            try context.save()
        } catch {
            throw SwiftDataServiceError.deleteFailed(error)
        }
    }
    
    /// 루틴 일괄 삭제
    static func deleteAllRoutines(for userId: String, context: ModelContext) throws {
        // 1. 해당 유저의 모든 루틴 가져오기
        let fetchDescriptor = FetchDescriptor<RoutineItem>()
        
        do {
            let userRoutines = try context.fetch(fetchDescriptor)

            for routine in userRoutines {
                context.delete(routine)
            }
            
            try context.save()
            print("✅ SwiftData: 모든 루틴 삭제 성공 for userId: \(userId)")
        } catch {
            print("❌ SwiftData: 루틴 삭제 실패 for userId: \(userId): \(error.localizedDescription)")
            throw SwiftDataServiceError.deleteFailed(error)
        }
    }
    
    static func resetRoutine(from routine: RoutineItem, context: ModelContext) throws {
        for task in routine.taskList {
            context.delete(task)
        }
        routine.taskList.removeAll()
        do {
            try context.save()
        } catch {
            throw SwiftDataServiceError.deleteFailed(error)
        }
    }
}
