//
//  RoutineStore.swift
//  Rouzzle
//
//  Created by 김동경 on 11/7/24.
//

import Foundation
import Factory
import Observation
import SwiftData

@Observable
class RoutineStore {
    var routineItem: RoutineItem
    var taskList: [TaskList] // 데이터 통신 x 스데에서 set할일 추가시 순서가 적용되지 않아 뷰에서만 사용하는 프로퍼티
    init(routineItem: RoutineItem) {
        print(routineItem.title)
        self.routineItem = routineItem
        self.taskList = routineItem.taskList
    }
    
    func addTask(_ todoTask: RecommendTodoTask, context: ModelContext) {
        do {
            try SwiftDataService.addTask(to: routineItem, todoTask.toTaskList(), context: context)
            taskList.append(todoTask.toTaskList())
        } catch {
            print("할일 추가 실패")
        }
    }
    
    func getRecommendTask() {
        guard let firstTime = routineItem.dayStartTime.first?.value, let time = firstTime.toDate() else {
            return
        }
        
        switch time.getTimeCategory() {
        case .morning:
            return
        case .afternoon:
            return
        case .evening:
            return
        case .night:
            return
        }
    }
    
    deinit {
        print("RoutineStore 해제")
    }
}
