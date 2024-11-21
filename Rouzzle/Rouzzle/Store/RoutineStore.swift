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
    
    var allRoutines: [RoutineItem] = [] // 모든 루틴 목록
    var routineItem: RoutineItem?
    var taskList: [TaskList] = [] // 데이터 통신 x 스데에서 set할일 추가시 순서가 적용되지 않아 뷰에서만 사용하는 프로퍼티
    var loadState: LoadState = . none
    var toastMessage: String?
    var recommendTodoTask: [RecommendTodoTask] = []
    var todayStartTime: String {
        if let routineItem = routineItem {
            let today = Date()
            let calendar = Calendar.current
            let weekdayNumber = calendar.component(.weekday, from: today)
            let value = routineItem.dayStartTime[weekdayNumber] ?? routineItem.dayStartTime.first?.value ?? ""
            return value.to12HourPeriod() + " " +  value.to12HourFormattedTime()
        }
        return ""
    }
    
    init() {
        fetchAllRoutines()
    }
    
    func fetchViewTask() {
        guard let routineItem = routineItem else { return }
        self.taskList = routineItem.taskList
        getRecommendTask()
    }
    /// 모든 루틴 데이터를 Firestore에서 가져오기
    func fetchAllRoutines() {
        Task {
            do {
                let routines = try await routineService.getAllRoutines()
                allRoutines = routines.map { RoutineItem(from: $0) } // 변환 적용
            } catch {
                toastMessage = "루틴 데이터를 가져오는 데 실패했습니다."
                print(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    func addTask(_ todoTask: RecommendTodoTask, context: ModelContext) async {
        loadState = .loading
        guard let routineItem = routineItem  else { return }
        do {
            var routine = routineItem.toRoutine()
            routine.routineTask.append(todoTask.toRoutineTask())
            let result = await routineService.updateRoutine(routine)
            switch result {
            case .success(()):
                try SwiftDataService.addTask(to: routineItem, todoTask.toTaskList(), context: context)
                taskList.append(todoTask.toTaskList())
                loadState = .completed
            case .failure:
                toastMessage = "할일 추가에 실패했습니다"
                loadState = .failed
            }
        } catch {
            toastMessage = "할일 추가에 실패했습니다"
            loadState = .failed
            print("할일 추가 실패")
        }
    }
    
    @MainActor
    func addTasks(_ todoTasks: [RecommendTodoTask], context: ModelContext) async {
        loadState = .loading
        guard let routineItem = routineItem  else { return }
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
                loadState = .completed
            } catch {
                loadState = .failed
                toastMessage = "할일 추가에 실패했습니다"
            }
        case .failure:
            loadState = .failed
            toastMessage = "할일 추가에 실패했습니다"
        }
    }
    
    /// 스위프트 데이터에만 추가하는 함수, 시트쪽에서 파베 업데이트 하므로 스데만 업데이트 하는 함수
    func addTaskSwiftData(_ todoTask: RecommendTodoTask, context: ModelContext) {
        loadState = .loading
        guard let routineItem = routineItem  else { return }

        do {
            try SwiftDataService.addTask(to: routineItem, todoTask.toTaskList(), context: context)
            loadState = .completed
        } catch {
            toastMessage = "할일 추가에 실패했습니다"
            loadState = .failed
            print("할 일 추가 실패")
        }
    }
    
    /// 추천 할 일 가져오는 함수
    func getRecommendTask() {
        guard let routineItem = routineItem  else { return }

        guard let firstTime = routineItem.dayStartTime.first?.value, let time = firstTime.toDate() else {
            return
        }
        let timeSet = time.getTimeCategory()
        let routineTitles = routineItem.taskList.map { $0.title }
        recommendTodoTask = DummyData.getRecommendedTasks(for: timeSet, excluding: routineTitles)
    }
    
    // 리팩 예정
    deinit {
        print("RoutineStore 해제")
    }
}
