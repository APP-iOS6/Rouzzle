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
    func scheduleNotification(id: String, title: String, body: String, date: Date) {
        print("Scheduling Notification: \(id), Title: \(title), Date: \(date)")
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: date), repeats: false)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for \(id) at \(date)")
            }
        }
    }

    // 다중 알람 스케줄 설정 (반복)
    // repeatCount 만큼 반복하여, intervalMinutes 간격으로 알림 추가하기
    func scheduleMultipleNotifications(id: String, title: String, startDate: Date, intervalMinutes: Int, repeatCount: Int) {
        guard repeatCount > 0 else {
            print("Invalid repeatCount: \(repeatCount). 반복 알림이 설정되지 않습니다.")
            return
        }
        
        print("scheduleMultipleNotifications 호출됨")
        print("Title: \(title)")
        print("Start Date: \(startDate)")
        print("Interval: \(intervalMinutes) 분")
        print("Repeat Count: \(repeatCount)")
        
        removeAllNotifications()
        
        // 첫 번째 알림 메시지
        let initialBody = "\(title)을 하러 갈 시간이에요!"
        scheduleNotification(id: "\(id)_initial", title: title, body: initialBody, date: startDate)
        
        // 반복 알림
        for i in 1...repeatCount {
            guard let notificationDate = Calendar.current.date(byAdding: .minute, value: intervalMinutes * i, to: startDate) else { continue }
            
            // 반복 알림 메시지
            let elapsedTime = intervalMinutes * i
            let repeatBody = "\(elapsedTime)분이 지났어요! \(title)을 시작하세요!"
            
            // 디버깅: 각 알림 시간 및 메시지 출력
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            print("반복알림 \(i): \(dateFormatter.string(from: notificationDate)), 메시지: \(repeatBody)")
            
            // 반복 알림 스케줄링
            let newId = "\(id)_repeat_\(i)"
            scheduleNotification(id: newId, title: title, body: repeatBody, date: notificationDate)
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
    
    // 알림 상태 확인
    func checkNotificationSettings(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }
}
