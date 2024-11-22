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
    
    // 알림 스케줄 추가
    func scheduleNotification(
        id: String,
        title: String,
        body: String,
        date: Date,
        repeats: Bool = false,
        weekdays: [Int]? = nil,
        isRoutineRunning: Bool
    ) {
        if isRoutineRunning {
            print("루틴 실행 중: 알림을 스케줄링하지 않습니다.")
            return
        }

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let center = UNUserNotificationCenter.current()
        let calendar = Calendar.current

        if let weekdays = weekdays, !weekdays.isEmpty {
            // 요일별 반복 알림
            for weekday in weekdays {
                var dateComponents = calendar.dateComponents([.hour, .minute], from: date)
                dateComponents.weekday = weekday

                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let weekdayID = "\(id)_weekday_\(weekday)"

                let request = UNNotificationRequest(identifier: weekdayID, content: content, trigger: trigger)

                center.add(request) { error in
                    if let error = error {
                        print("Error scheduling notification for weekday \(weekday): \(error.localizedDescription)")
                    } else {
                        print("Notification scheduled for weekday \(weekday)")
                    }
                }
            }
        } else {
            // 단일 또는 전체 반복 알림 (기존 동작)
            let trigger = UNCalendarNotificationTrigger(dateMatching: calendar.dateComponents([.hour, .minute], from: date), repeats: repeats)

            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

            center.add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled at \(date)")
                }
            }
        }
    }

    // 다중 알람 스케줄 설정 (반복)
    // repeatCount 만큼 반복하여, intervalMinutes 간격으로 알림 추가하기
    func scheduleMultipleNotifications(
        id: String,
        title: String,
        startDate: Date,
        intervalMinutes: Int,
        repeatCount: Int,
        weekdays: [Int]? = nil,
        isRoutineRunning: Bool
    ) {
        guard !isRoutineRunning else {
            print("루틴 실행 중: 반복 알림을 스케줄링하지 않습니다.")
            return
        }

        if let weekdays = weekdays, !weekdays.isEmpty {
            // 요일별 반복 알림 설정
            for weekday in weekdays {
                guard let notificationDate = Calendar.current.date(byAdding: .minute, value: intervalMinutes, to: startDate) else { continue }
                scheduleNotification(
                    id: "\(id)_weekday_\(weekday)",
                    title: title,
                    body: "\(title)을 시작하세요!",
                    date: notificationDate,
                    repeats: true,
                    weekdays: [weekday],
                    isRoutineRunning: false
                )
            }
        } else {
            // 기존 반복 알림
            for i in 0..<repeatCount {
                guard let notificationDate = Calendar.current.date(byAdding: .minute, value: intervalMinutes * i, to: startDate) else { continue }

                let repeatBody = "\(title)을 시작하세요!"
                scheduleNotification(
                    id: "\(id)_repeat_\(i)",
                    title: title,
                    body: repeatBody,
                    date: notificationDate,
                    repeats: false,
                    isRoutineRunning: false
                )
            }
        }
    }

    
    // 포그라운드때도 알림 표시
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    // 기존 알림 제거
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("기존 알림이 모두 제거되었습니다.")
    }
    
    // 특정 알림 ID를 기반으로 알림 취소
    func removeNotifications(withPrefix prefix: String) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let idsToRemove = requests
                .filter { $0.identifier.hasPrefix(prefix) }
                .map { $0.identifier }
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: idsToRemove)
            print("\(idsToRemove.count)개의 알림이 취소되었습니다. (Prefix: \(prefix))")
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
