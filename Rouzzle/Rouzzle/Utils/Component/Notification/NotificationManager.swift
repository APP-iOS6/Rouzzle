//
//  NotificationManager.swift
//  Rouzzle
//
//  Created by 이다영 on 11/19/24.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    // 알림 권한 요청
    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error requesting notification permission: \(error.localizedDescription)")
                }
                completion(granted)
            }
        }
    }
    
    // 단일 알림 스케줄
    func scheduleNotification(id: String, title: String, body: String, date: Date, repeats: Bool = false, isRoutineRunning: Bool) {
        if isRoutineRunning {
            print("루틴 실행 중: 알림을 스케줄링하지 않습니다.")
            return
        }
        
        print("Scheduling Notification: \(id), Title: \(title), Date: \(date)")
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.weekday, .hour, .minute], from: date), repeats: repeats)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
//                print("Notification scheduled for \(id) at \(date)")
            }
        }
    }

    // 다중 알람 스케줄 설정 (단일+반복)
    // repeatCount 만큼 반복하여, intervalMinutes 간격으로 알림 추가하기
    func scheduleMultipleNotifications(id: String, title: String, startDate: Date, intervalMinutes: Int, repeatCount: Int, repeats: Bool = false, isRoutineRunning: Bool) {
        guard !isRoutineRunning else {
            print("루틴 실행 중: 반복 알림을 스케줄링하지 않습니다.")
            return
        }
        
        print("scheduleMultipleNotifications 호출됨")
//        print("Title: \(title)")
//        print("Start Date: \(startDate)")
//        print("Interval: \(intervalMinutes) 분")
//        print("Repeat Count: \(repeatCount)")
        
        removeAllNotifications()
        
        // 첫 번째 알림 메시지
        let initialBody = "지금 바로 시작해볼까요?"
        scheduleNotification(id: "\(id)_initial", title: title, body: initialBody, date: startDate, repeats: repeats, isRoutineRunning: isRoutineRunning)
        
        // 반복 알림
        for i in 1...repeatCount {
            guard let notificationDate = Calendar.current.date(byAdding: .minute, value: intervalMinutes * i, to: startDate) else { continue }
            
            // 요일과 시간을 포함한 DateComponents 생성
            var components = Calendar.current.dateComponents([.hour, .minute], from: notificationDate)
            components.weekday = Calendar.current.component(.weekday, from: startDate) // 시작 날짜의 요일 가져오기
            
            // 반복 알림 메시지
            let elapsedTime = intervalMinutes * i
            let repeatBody = "\(elapsedTime)분이 지났어요! 지금 시작하세요!"
            
            // 디버깅: 각 알림 시간 및 메시지 출력
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            print("반복알림 \(i): \(dateFormatter.string(from: notificationDate)), 메시지: \(repeatBody)")
            
            // 반복 알림 스케줄링
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = repeatBody
            content.sound = .default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
            let newId = "\(id)_repeat_\(i)"
            let request = UNNotificationRequest(identifier: newId, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } /*else {
                    print("Scheduled Notification \(newId) with components: \(components)")
                }*/
            }
        }
    }
    
    // 단일, 반복 알림 종합 설정
    func scheduleRoutineNotifications(
            idPrefix: String,
            title: String,
            dayStartTime: [Day: Date],
            intervalMinutes: Int,
            repeatCount: Int,
            repeats: Bool = true,
            isRoutineRunning: Bool = false
        ) {
            guard !dayStartTime.isEmpty else {
                print("알림 설정 실패: 시작 시간이 설정되지 않았습니다.")
                return
            }

            // 모든 알림 제거
            removeAllNotifications()

            for (day, time) in dayStartTime {
                guard let routineStartDate = Calendar.current.nextDate(
                    after: Date(),
                    matching: Calendar.current.dateComponents([.hour, .minute], from: time),
                    matchingPolicy: .nextTime
                ) else { continue }

                let alarmID = "\(idPrefix)_day_\(day.rawValue)"
                scheduleMultipleNotifications(
                    id: alarmID,
                    title: title,
                    startDate: routineStartDate,
                    intervalMinutes: intervalMinutes,
                    repeatCount: repeatCount,
                    repeats: repeats,
                    isRoutineRunning: isRoutineRunning
                )
            }
            print("요일별 알림이 스케줄링되었습니다.")
        }
    
    // 포그라운드때도 알림 표시
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    // 기존 알림 제거
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//        print("기존 알림이 모두 제거되었습니다.")
    }
    
    // 특정 알림 ID를 기반으로 알림 취소
    func removeNotifications(withPrefix prefix: String) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let idsToRemove = requests
                .filter { $0.identifier.hasPrefix(prefix) }
                .map { $0.identifier }
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: idsToRemove)
            print("\(idsToRemove.count)의 알림이 취소되었습니다. (Prefix: \(prefix))")
        }
    }
    
    // 알림 상태 확인
    func checkNotificationSettings(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }
}
