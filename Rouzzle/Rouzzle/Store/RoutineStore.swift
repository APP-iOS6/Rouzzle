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
    var errorMessage: String?
    var recommendTodoTask: [RecommendTodoTask] = []
    var todayStartTime: String {
        let today = Date()
        let calendar = Calendar.current
        let weekdayNumber = calendar.component(.weekday, from: today)
        let value = routineItem.dayStartTime[weekdayNumber] ?? routineItem.dayStartTime.first?.value ?? ""
        return value.to12HourPeriod() + " " +  value.to12HourFormattedTime()
    }
    
    init(routineItem: RoutineItem) {
        print(routineItem.title)
        self.routineItem = routineItem
        self.taskList = routineItem.taskList
        getRecommendTask()
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
            case .failure:
                errorMessage = "할일 추가에 실패했습니다"
            }
        } catch {
            errorMessage = "할일 추가에 실패했습니다"
            print("할일 추가 실패")
        }
    }
    
    @MainActor
    func addTasks(_ todoTasks: [RecommendTodoTask], context: ModelContext) async {
        var routine = routineItem.toRoutine()
        for task in todoTasks {
            routine.routineTask.append(task.toRoutineTask())
        }
        let result = await routineService.updateRoutine(routine)
        switch result {
        case .success(()):
            do {
                for task in todoTasks {
                    try SwiftDataService.addTask(to: routineItem, task.toTaskList(), context: context)
                }
            } catch {
                errorMessage = "할일 추가에 실패했습니다"
            }
        case .failure:
            errorMessage = "할일 추가에 실패했습니다"
        }
    }
    
    /// 스위프트 데이터에만 추가하는 함수
    func addTaskSwiftData(_ todoTask: RecommendTodoTask, context: ModelContext) {
        do {
            try SwiftDataService.addTask(to: routineItem, todoTask.toTaskList(), context: context)
        } catch {
            errorMessage = "할일 추가에 실패했습니다"
            print("할 일 추가 실패")
        }
    }
    
    /// 추천 할 일 가져오는 함수
    func getRecommendTask() {
        guard let firstTime = routineItem.dayStartTime.first?.value, let time = firstTime.toDate() else {
            return
        }
        let timeSet = time.getTimeCategory()
        print(timeSet)
        let routineTitles = routineItem.taskList.map { $0.title }
        recommendTodoTask = DummyData.getRecommendedTasks(for: timeSet, excluding: routineTitles)
    }
    
    // 리팩 예정
    deinit {
        print("RoutineStore 해제")
    }
}
