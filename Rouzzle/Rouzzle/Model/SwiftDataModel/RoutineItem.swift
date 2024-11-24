//
//  RoutineItem.swift
//  Rouzzle
//
//  Created by 김정원 on 11/7/24.
//

import Foundation
import SwiftData

@Model
/// 루틴에 대한 기본적인 정보
final class RoutineItem {
    var id: String = ""
    var title: String
    var taskList: [TaskList]
    var repeatCount: Int
    var interval: Int
    var dayStartTime: [Int: Date] // 각 요일 별 시작시간
    var alarmIDs: [Int: String] // 알람 id
    
    init(title: String, taskList: [TaskList], repeatCount: Int, interval: Int, dayStartTime: [Int: Date], alarmIDs: [Int: String]) {
        self.title = title
        self.taskList = taskList
        self.repeatCount = repeatCount
        self.interval = interval
        self.dayStartTime = dayStartTime
        self.alarmIDs = alarmIDs
    }
}

@Model
final class TaskList {
    var title: String // 할일 제목
    var emoji: String // 이모지
    var timer: Int // 타이머
    var isCompleted: Bool
    
    init(title: String, emoji: String, timer: Int, isCompleted: Bool) {
        self.title = title
        self.emoji = emoji
        self.timer = timer
        self.isCompleted = isCompleted
    }
}
