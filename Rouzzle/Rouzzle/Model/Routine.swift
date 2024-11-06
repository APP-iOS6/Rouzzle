//
//  Routine.swift
//  Rouzzle
//
//  Created by 김동경 on 11/6/24.
//

import Foundation
import FirebaseFirestore

struct Routine: Codable {
    @DocumentID var documentId: String?
    var title: String
    var routineTask: [RoutineTask]
    var repeatCount: Int // 예: 1, 3, 5
    var interval: Int // 분 단위, 예: 1, 3, 5
    var dayStartTime: [Int: Date] // 각 요일 별 시작시간
    var alarmIDs: [Int: String] // 알람 id
    var userId: String // 루틴을 가지고 있는 유저의 uid
}

struct RoutineTask: Codable {
    var title: String // 할일 제목
    var emoji: String // 이모지
    var timer: TimeInterval // 타이머
}

enum Day: Int, Codable, CaseIterable {
    case sunday = 0
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    var name: String {
        let formatter = DateFormatter()
        return formatter.weekdaySymbols[self.rawValue - 1]
    }
}

let routineDummy1 = Routine(title: "아침루틴", routineTask: [RoutineTask(title: "물마시기", emoji: "😀", timer: 5)], repeatCount: 5, interval: 2, dayStartTime: [0: Date(), 3: Date()], alarmIDs: [0: "sunday1", 1: "monday1"], userId: "dongkyung")
