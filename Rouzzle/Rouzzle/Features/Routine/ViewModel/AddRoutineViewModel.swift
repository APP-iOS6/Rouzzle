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
    var isNotificationEnabled: Bool = false {
        didSet {
            if isNotificationEnabled {
                interval = interval ?? 1 // 기본값: 1분
                repeatCount = repeatCount ?? 1 // 기본값: 1번
            } else {
                interval = nil
                repeatCount = nil
            }
            updateAlarmIDs()
        }
    }
    var repeatCount: Int?  // 예: 1, 3, 5
    var interval: Int?  // 분 단위, 예: 1, 3, 5
    var alarmIDs: [Int: String]?
    var routineTask: [RoutineTask] = []
    var recommendTodoTask: [RecommendTodoTask] = [] // 추천 할일 리스트 목록
    var toastMessage: String?
    var loadState: LoadState = .none

    var disabled: Bool {
        selectedDateWithTime.isEmpty || title.isEmpty
    }
    
    // 알림 ID 생성/초기화 로직
    private func updateAlarmIDs() {
        if isNotificationEnabled {
            // 알림 ID 생성
            alarmIDs = generateAlarmIDs(for: selectedDateWithTime)
        } else {
            // 알림 비활성화 시 초기화
            alarmIDs = nil
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
            selectedDateWithTime.removeValue(forKey: day)
        } else {
            selectedDateWithTime[day] = Date()
        }
        isDaily = selectedDateWithTime.keys.count == Day.allCases.count
        updateAlarmIDs()
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
        updateAlarmIDs()
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
        updateAlarmIDs()
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
        let _ = interval ?? 1
        let _ = repeatCount ?? 1
        
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
            alarmIDs: alarmIDs,
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
    
    // notification 함수
    func handleNotificationToggle() {
        if isNotificationEnabled {
            // 알림 켜기 - 권한 요청 확인
            NotificationManager.shared.checkNotificationSettings { status in
                switch status {
                case .authorized:
                    // 이미 권한이 있음 - 알람 스케줄
                    self.scheduleRoutineNotifications(isRoutineRunning: false)
                case .denied:
                    self.isNotificationEnabled = false
                    self.toastMessage = "알림 권한이 꺼져 있습니다. 설정에서 권한을 활성화해주세요."
                case .notDetermined:
                    NotificationManager.shared.requestNotificationPermission { granted in
                        if granted {
                            self.scheduleRoutineNotifications(isRoutineRunning: false)
                        } else {
                            self.isNotificationEnabled = false
                            self.toastMessage = "알림 권한이 거부되었습니다."
                        }
                    }
                default:
                    break
                }
            }
        } else {
            // 알림 끄기 - 기존 알림 제거
            NotificationManager.shared.removeAllNotifications()
        }
    }
    
    func scheduleRoutineNotifications(isRoutineRunning: Bool) {
        guard let startDate = selectedDateWithTime.values.first else {
            print("알림 시작 시간이 설정되지 않았습니다.")
            return
        }
        
        // 기본값 확인: repeatCount와 interval이 설정되지 않은 경우 기본값 적용
        let validRepeatCount = repeatCount ?? 1
        let validInterval = interval ?? 1
        
        // 유효성 검사 추가
        guard validRepeatCount > 0 else {
            print("repeatCount가 유효하지 않아 알림을 설정하지 않습니다. 값: \(validRepeatCount)")
            return
        }
        
        NotificationManager.shared.removeAllNotifications()
        
        // 디버깅: 설정된 값 확인
        print("scheduleRoutineNotifications 호출됨")
        print("알림 설정 시간: \(selectedDateWithTime)")
        print("시작 날짜: \(startDate)")
        print("Repeat Count: \(validRepeatCount)")
        print("Interval Minutes: \(validInterval)")
        
        NotificationManager.shared.scheduleMultipleNotifications(
            id: UUID().uuidString,
            title: title,
            startDate: startDate,
            intervalMinutes: validInterval, // 기본값 1분
            repeatCount: validRepeatCount, // 기본값 0회 반복
            repeats: true,
            isRoutineRunning: isRoutineRunning
        )
    }
    
    @MainActor
    func startRoutine() {
        guard let alarmPrefix = alarmIDs?.values.first else {
            print("알람 ID가 없습니다.")
            return
        }
        // 이후 알림 취소
        NotificationManager.shared.removeNotifications(withPrefix: alarmPrefix)
        print("루틴 실행 시작으로 이후 알림 취소")
    }
}
