//
//  EditRoutineViewModel.swift
//  Rouzzle
//
//  Created by 김동경 on 11/11/24.
//

import Foundation
import Factory
import Observation
import SwiftData

@Observable
class EditRoutineViewModel {
    
    @ObservationIgnored
    @Injected(\.routineService) private var routineService
    
    var routine: RoutineItem
    var editRoutine: RoutineEditData
    var tempdayStartTime: [Day: Date] = [:]
    var isDaily: Bool = false
    var isNotificationEnabled: Bool = false {
        didSet {
            updateAlarmIDs() // 알림 상태 변경 시 알림 ID 업데이트
        }
    }
    var deleteTasks: [TaskEditData] = []
    var loadState: LoadState = .none
    var errorMessage: String?
    
    init(routine: RoutineItem) {
        self.routine = routine
        self.tempdayStartTime = routine.dayStartTime.toDayDateDictionary()
        self.isNotificationEnabled = routine.repeatCount != nil
        self.editRoutine = routine.toRoutineEditData()
        self.editRoutine.interval = routine.interval ?? 1
        self.editRoutine.repeatCount = routine.repeatCount ?? 1
        updateAlarmIDs()
    }
    
    // 알림 id 생성/초기화
    private func updateAlarmIDs() {
        if isNotificationEnabled {
            editRoutine.alarmIDs = generateAlarmIDs(for: tempdayStartTime)
        } else {
            editRoutine.alarmIDs = nil
        }
    }
    
    private func generateAlarmIDs(for dates: [Day: Date]) -> [Int: String] {
        var alarmIDs: [Int: String] = [:]
        for (day, _) in dates {
            // UUID 기반 고유 ID 생성
            alarmIDs[day.rawValue] = UUID().uuidString
        }
        return alarmIDs
    }
    
    // 개별 요일 토글
    func toggleDay(_ day: Day) {
        if isSelected(day) {
            tempdayStartTime.removeValue(forKey: day)
        } else {
            tempdayStartTime[day] = Date()
        }
        isDaily = tempdayStartTime.keys.count == Day.allCases.count
        updateAlarmIDs()
    }
    
    func toggleDaily() {
        if isDaily {
            // 해제: 모든 요일 해제
            tempdayStartTime.removeAll()
            isDaily = false
        } else {
            // 설정: 모든 요일 선택하고 현재 시간 설정
            let currentDate = Date()
            for day in Day.allCases {
                tempdayStartTime[day] = currentDate
            }
            isDaily = true
        }
        updateAlarmIDs()
    }
    
    // 요일 시간 한번에 수정했을 때 불리는 함수
    func selectedDayChangeDate(_ date: Date) {
        for day in tempdayStartTime.keys {
            tempdayStartTime[day] = date
        }
        updateAlarmIDs()
    }
    
    // 특정 요일이 선택되어 있는지 확인하는 함수
    func isSelected(_ day: Day) -> Bool {
        return tempdayStartTime[day] != nil
    }
    
    // 데이터 저장에는 딕셔너리 타입이 Int: String이기 때문에 selectedDateWithTime의 타입을 변환하는 함수(Extension 사용)
    func selectedDateWithTimeTypeChange() -> [Int: String] {
        return tempdayStartTime.mapKeys { $0.rawValue }
            .mapValues { $0.formattedToTime() }
    }
    
    @MainActor
    func updateRoutine(context: ModelContext) async {
        loadState = .loading
        var routine = editRoutine.toRoutine()
        routine.dayStartTime = selectedDateWithTimeTypeChange()
        let result = await routineService.updateRoutine(routine)
        switch result {
        case .success:
            do {
                try SwiftDataService.resetRoutine(from: self.routine, context: context)
                for task in editRoutine.taskList {
                    try SwiftDataService.addTask(to: self.routine, task.toTaskList(), context: context)
                }
                saveRoutine()
                try context.save()
                // 알림 설정 로직 추가
                if isNotificationEnabled {
                    scheduleNotifications(isRoutineRunning: false)
                } else {
                    NotificationManager.shared.removeAllNotifications()
                    print("기존 알림이 모두 제거되었습니다.")
                }
                loadState = .completed
            } catch {
                loadState = .failed
                errorMessage = "루틴 수정 실패"
            }
        case .failure:
            loadState = .failed
            errorMessage = "루틴 수정 실패"
        }
    }
    
    @MainActor
    func createRoutine(context: ModelContext) async {
        loadState = .loading
        var routine = editRoutine.toRoutine()
        routine.documentId = nil
        routine.dayStartTime = selectedDateWithTimeTypeChange()
        
        let result = await routineService.addRoutine(routine)
        switch result {
        case let .success(uploadRoutine):
            do {
                let routineItem = uploadRoutine.toRoutineItem()
                routineItem.taskList.removeAll()
                try SwiftDataService.addRoutine(routineItem, context: context)
                for task in uploadRoutine.routineTask.map({ $0.toTaskList() }) {
                    try SwiftDataService.addTask(to: routineItem, task, context: context)
                }
                // 알림 설정 로직 추가
                if isNotificationEnabled {
                    scheduleNotifications(isRoutineRunning: false)
                } else {
                    NotificationManager.shared.removeAllNotifications()
                }
                loadState = .completed
            } catch {
                errorMessage = "루틴 등록에 실패했습니다."
                loadState = .failed
            }
        case .failure:
            errorMessage = "루틴 등록에 실패했습니다."
            loadState = .failed
        }
    }
    
    func saveRoutine() {
        // 루틴의 기본 속성 업데이트
        routine.title = editRoutine.title
        routine.emoji = editRoutine.emoji
        routine.dayStartTime = selectedDateWithTimeTypeChange()
        routine.interval = editRoutine.interval
        routine.repeatCount = editRoutine.repeatCount
        routine.alarmIDs = editRoutine.alarmIDs
    }
    
    // 알림 스케줄링
    func scheduleNotifications(isRoutineRunning: Bool) {
        guard let interval = editRoutine.interval, let repeatCount = editRoutine.repeatCount else {
                print("알림 설정 실패: interval 또는 repeatCount가 설정되지 않았습니다.")
                return
            }

            NotificationManager.shared.scheduleRoutineNotifications(
                idPrefix: "\(routine.id)",
                title: editRoutine.title,
                dayStartTime: tempdayStartTime,
                intervalMinutes: interval,
                repeatCount: repeatCount,
                repeats: true,
                isRoutineRunning: isRoutineRunning
            )
    }
}
