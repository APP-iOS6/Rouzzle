//
//  UsersRoutine.swift
//  Rouzzle
//
//  Created by 김정원 on 11/7/24.
//

import Foundation
import SwiftData

@Model
final class UsersRoutine {
    var name: String
    var routines: [RoutineItem]
    var lastCreatedDate: Date
    
    init(name: String, routines: [RoutineItem], date: Date) {
        self.name = name
        self.routines = routines
        self.lastCreatedDate = date
        
        if !isLastCreatedDateToday() {
            resetRoutineTasks()
        }
    }
    
    /// lastCreatedDate가 오늘 날짜와 같은지 비교하고, 항상 오늘 날짜로 업데이트하는 메서드
    func isLastCreatedDateToday() -> Bool {
        if !Calendar.current.isDate(lastCreatedDate, inSameDayAs: Date()) {
            print("오늘 접속하지 않았습니다. 마지막 생성날짜를 오늘로 설정합니다.")
            self.lastCreatedDate = Date()
            return false
        }
        return true
    }
    
    /// 모든 루틴 테스크의 진행 상황을 리셋하는 메서드
    func resetRoutineTasks() {
        for routine in routines {
            for task in routine.taskList {
                task.isCompleted = false
            }
        }
    }
}
