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
    
    @ObservationIgnored
    @Injected(\.routineService) private var routineService
    
    var routineItem: RoutineItem
    var taskList: [TaskList] // 데이터 통신 x 스데에서 set할일 추가시 순서가 적용되지 않아 뷰에서만 사용하는 프로퍼티
    var loadState: LoadState = . none
    var erorrMessage: String?
    
    init(routineItem: RoutineItem) {
        print(routineItem.title)
        self.routineItem = routineItem
        self.taskList = routineItem.taskList
    }
    
    @MainActor
    func addTask(_ todoTask: RecommendTodoTask, context: ModelContext) async {
        do {
            var routine = routineItem.toRoutine()
            routine.routineTask.append(todoTask.toRoutineTask())
            let result = await routineService.updateRoutine(routine)
            switch result {
            case .success(()):
                try SwiftDataService.addTask(to: routineItem, todoTask.toTaskList(), context: context)
                taskList.append(todoTask.toTaskList())
            case let .failure(error):
                print(error.localizedDescription)
            }
        } catch {
            print("할일 추가 실패")
        }
    }
    
    func addTaskSwiftData(_ todoTask: RecommendTodoTask, context: ModelContext) {
        do {
            try SwiftDataService.addTask(to: routineItem, todoTask.toTaskList(), context: context)
        } catch {
            print("할 일 추가 실패")
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
