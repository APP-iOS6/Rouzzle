//
//  RoutineManager.swift
//  Rouzzle
//
//  Created by 이다영 on 11/21/24.
//
import Foundation

class RoutineManager {
    static let shared = RoutineManager()
    
    private(set) var isRoutineRunning: Bool = false
    
    func startRoutine() {
        isRoutineRunning = true
        print("루틴이 시작되었습니다. 실행 상태: \(isRoutineRunning)")
        
        // 기존 알림 제거
        NotificationManager.shared.removeAllNotifications()
    }
    
    func stopRoutine() {
        isRoutineRunning = false
        print("루틴이 종료되었습니다. 실행 상태: \(isRoutineRunning)")
    }
}
