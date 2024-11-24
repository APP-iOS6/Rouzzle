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
    @ObservationIgnored
    @Injected(\.userService) private var userService
    
    var allRoutines: [RoutineItem] = [] // 모든 루틴 목록
    var routineItem: RoutineItem?
    var taskList: [TaskList] = [] // 데이터 통신 x 스데에서 set할일 추가시 순서가 적용되지 않아 뷰에서만 사용하는 프로퍼티
    var loadState: LoadState = . none
    var puzzleLoad: LoadState = .none
    var phase: Phase = .loading
    var toast: ToastModel?
    var toastMessage: String?
    var homeToastMessage: String? // 루틴 리스트(홈) 에서 보여질 토스트 메시지
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
    // 내 퍼즐 조각 개수
    var myPuzzle: Int = 0
    
    init() {
        fetchMyData()
    }
        
    func fetchViewTask() {
        guard let routineItem = routineItem else { return }
        self.taskList = routineItem.taskList
    }
    
    func selectedRoutineItem(_ routine: RoutineItem) {
        routineItem = routine
        taskList = routine.taskList
    }
    
    func fetchMyData() {
        self.puzzleLoad = .loading
        Task {
            let userUid = Utils.getUserUUID()
            let result = await userService.fetchUserData(userUid)
            switch result {
            case let .success(user):
                DispatchQueue.main.async {
                    self.myPuzzle = user.puzzleCount
                    self.puzzleLoad = .completed
                }
            case .failure:
                DispatchQueue.main.async {
                    self.toast = ToastModel(type: .warning, message: "퍼즐 조각 로드에 실패했습니다 다시 시도해 주세요.")
                    self.puzzleLoad = .failed
                }
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
                getRecommendTask()
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
                    taskList.append(task.toTaskList())
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
    
    func deleteRoutine(
        modelContext: ModelContext,
        completeAction: @escaping (String) -> Void,
        dismiss: @escaping () -> Void
    ) {
        guard let routineItem = routineItem else { return }
        Task {
            loadState = .loading
            let routineToDelete = routineItem.toRoutine()
            
            // RoutineCompletion 삭제
            let completionDeleteResult = await routineService.removeRoutineCompletions(for: routineToDelete.documentId ?? "")
            switch completionDeleteResult {
            case .success:
                print("✅ RoutineCompletion 삭제 성공")
            case .failure(let error):
                print("❌ RoutineCompletion 삭제 실패: \(error.localizedDescription)")
                loadState = .failed
                return
            }
            
            // Firestore 루틴 삭제
            let firebaseResult = await routineService.removeRoutine(routineToDelete)
            switch firebaseResult {
            case .success:
                print("✅ 파이어베이스 루틴 삭제 성공")
            case .failure(let error):
                print("❌ 파이어베이스 루틴 삭제 실패: \(error.localizedDescription)")
                loadState = .failed
                return
            }
            
            // SwiftData에서 삭제
            do {
                try SwiftDataService.deleteRoutine(routine: routineItem, context: modelContext)
                print("✅ 스위프트 데이터 루틴 삭제 성공")
                completeAction("루틴이 삭제되었습니다.")
            } catch {
                print("❌ 스위프트 데이터 루틴 삭제 실패: \(error.localizedDescription)")
                loadState = .failed
                return
            }
            loadState = .completed
            dismiss()
        }
    }
    
    /// 오늘 보상을 받았다면 true 아직 안받았다면 false -> 안받았따면 퍼즐 부여
    func checkTodayPuzzleReward() async {
        DispatchQueue.main.async {
            self.puzzleLoad = .loading
        }
        let userUid = Utils.getUserUUID()
        let now = Date()
        let calendar = Calendar.current
        let date = calendar.startOfDay(for: now)
        let result = await userService.checkTodayPuzzleReward(userUid, date: date)
        
        switch result {
        case let .success(check):
            if !check {
                switch await userService.uploadTodayPuzzleReward(userUid, date: date) {
                case .success:
                    DispatchQueue.main.async {
                        self.puzzleLoad = .completed
                        self.toast = ToastModel(type: .getOnePuzzle)
                        self.fetchMyData()
                    }
                case .failure:
                    DispatchQueue.main.async {
                        self.puzzleLoad = .none
                        self.toast = ToastModel(type: .warning, message: "퍼즐 부여에 실패했습니다. 루틴을 다시 시도해주세요.")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.puzzleLoad = .completed
                }
                self.fetchMyData()
            }
        case .failure:
            DispatchQueue.main.async {
                self.puzzleLoad = .failed
                self.toast = ToastModel(type: .warning, message: "리워드 정보를 불러오지 못했습니다. 다시 시도해 주세요.")
            }
        }
    }
    
    // 리팩 예정
    deinit {
        print("RoutineStore 해제")
    }
}
