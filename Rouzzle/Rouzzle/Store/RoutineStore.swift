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
    var loadState: LoadState = . none
    
    init(routineItem: RoutineItem) {
        print(routineItem.title)
        self.routineItem = routineItem
    }
    
    func addTask(_ todoTask: RecommendTodoTask, context: ModelContext) {
        do {
            try SwiftDataService.addTask(to: routineItem, todoTask.toTaskList(), context: context)
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
    
    // 리팩 예정
    deinit {
        print("RoutineStore 해제")
    }
}
