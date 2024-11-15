//
//  AddRoutineViewModel.swift
//  Rouzzle
//
//  Created by 김동경 on 11/8/24.
//

import Factory
import Foundation
import FirebaseAuth
import Observation
import SwiftData

@Observable
class AddRoutineViewModel {
    
    enum Step: Double {
        case info = 0.5
        case task = 1.0
    }
    
    @ObservationIgnored
    @Injected(\.routineService) private var routineService
    
    var step: Step = .info
    var title: String = ""
    var selectedEmoji: String? = "🧩"
    var selectedDateWithTime: [Day: Date] = [:]
    var isDaily: Bool = false
    var isNotificationEnabled: Bool = false
    var repeatCount: Int?  // 예: 1, 3, 5
    var interval: Int?  // 분 단위, 예: 1, 3, 5
    var routineTask: [RoutineTask] = []
    var recommendTodoTask: [RecommendTodoTask] = [] // 추천 할일 리스트 목록
    var toastMessage: String?
    var loadState: LoadState = .none

    var disabled: Bool {
        selectedDateWithTime.isEmpty || title.isEmpty
    }
    
    // 개별 요일 토글
    func toggleDay(_ day: Day) {
        if isSelected(day) {
            selectedDateWithTime.removeValue(forKey: day)
        } else {
            selectedDateWithTime[day] = Date()
        }
        isDaily = selectedDateWithTime.keys.count == Day.allCases.count
    }
    
    // 매일 토글 버튼 누를 시 동작하는 함수
    func toggleDaily() {
        if isDaily {
            // 해제: 모든 요일 해제
            selectedDateWithTime.removeAll()
            isDaily = false
        } else {
            // 설정: 모든 요일 선택하고 현재 시간 설정
            let currentDate = Date()
            for day in Day.allCases {
                selectedDateWithTime[day] = currentDate
            }
            isDaily = true
        }
    }
    
    // 특정 요일이 선택되어 있는지 확인하는 함수
    func isSelected(_ day: Day) -> Bool {
        return selectedDateWithTime[day] != nil
    }
    
    // 요일 시간 한번에 수정했을 때 불리는 함수
    func selectedDayChangeDate(_ date: Date) {
        for day in selectedDateWithTime.keys {
            selectedDateWithTime[day] = date
        }
    }
    
    // 데이터 저장에는 딕셔너리 타입이 Int: String이기 때문에 selectedDateWithTime의 타입을 변환하는 함수(Extension 사용)
    func selectedDateWithTimeTypeChange() -> [Int: String] {
        return selectedDateWithTime.mapKeys { $0.rawValue }
            .mapValues { $0.formattedToTime() }
    }
    
    /// 시간 대에 따른 추천 task 리스트 셋 가져오는 함수
    func getRecommendTask() {
        guard let time = selectedDateWithTime.first?.value else {
            return
        }
        let timeSet = time.getTimeCategory()
        let routineTitles = routineTask.map { $0.title }
        recommendTodoTask = DummyData.getRecommendedTasks(for: timeSet, excluding: routineTitles)
    }
    
    @MainActor
    func uploadRoutine(context: ModelContext) {
        let userUid = Auth.auth().currentUser?.uid ?? Utils.getDeviceUUID()
        loadState = .loading
        // TODO: AlarmIds 추가
        let createRoutine = Routine(
            title: title,
            emoji: selectedEmoji ?? "🧩",
            routineTask: routineTask,
            repeatCount: repeatCount,
            interval: interval,
            dayStartTime: selectedDateWithTimeTypeChange(),
            userId: userUid
        )

        Task {
            let routine = await routineService.addRoutine(createRoutine)
            switch routine {
            case let .success(result):
                do {
                    let routineItem = result.toRoutineItem()
                    routineItem.taskList.removeAll()
                    try SwiftDataService.addRoutine(routineItem, context: context)
                    for task in routineTask.map({ $0.toTaskList() }) {
                        try SwiftDataService.addTask(to: routineItem, task, context: context)
                    }
                    self.loadState = .completed
                } catch {
                    self.loadState = .failed
                    self.toastMessage = "기기에 루틴을 저장하지 못했습니다."
                }
            case .failure:
                self.loadState = .failed
                self.toastMessage = "루틴을 저장하지 못했습니다."
            }
        }
    }
}
