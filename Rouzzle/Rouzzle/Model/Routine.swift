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
    var emoji: String
    var routineTask: [RoutineTask]
    var repeatCount: Int? // 예: 1, 3, 5
    var interval: Int? // 분 단위, 예: 1, 3, 5
    var dayStartTime: [Int: Date] // 각 요일 별 시작시간
    var alarmIDs: [Int: String]? // 알람 id
    var userId: String // 루틴을 가지고 있는 유저의 uid
    
    func toRoutineItem() -> RoutineItem {
        return RoutineItem(
            title: title,
            emoji: emoji,
            dayStartTime: dayStartTime,
            repeatCount: repeatCount,
            interval: interval,
            alarmIDs: alarmIDs,
            userId: userId
        )
    }
}

struct RoutineTask: Codable {
    var title: String // 할일 제목
    var emoji: String // 이모지
    var timer: Int // 타이머
    
    func toTaskList() -> TaskList {
        return TaskList(title: title, emoji: emoji, timer: timer)
    }
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
