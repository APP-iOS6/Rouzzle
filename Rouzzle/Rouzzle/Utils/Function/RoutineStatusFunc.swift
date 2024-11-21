//
//  TodayStartTime.swift
//  Rouzzle
//
//  Created by 김동경 on 11/21/24.
//

import Foundation

func todayStartTime(_ dictionary: [Int: String]) -> String {
    let today = Date()
    let calendar = Calendar.current
    let weekdayNumber = calendar.component(.weekday, from: today)
    let value = dictionary[weekdayNumber] ?? dictionary.first?.value ?? ""
    return value.to12HourPeriod() + " " + value.to12HourFormattedTime()
}

func returnRoutineStatus(_ taskList: [TaskList]) -> RoutineStatus {
    return ((taskList.filter { $0.isCompleted }.count == taskList.count) && !taskList.isEmpty) ? .completed : .pending
}

func inProgressCount(_ taskList: [TaskList]) -> String {
    let completedTaskCount = taskList.filter { $0.isCompleted }.count
    if completedTaskCount == 0 {
        return ""
    }
    return "\(completedTaskCount)/\(taskList.count)"
}

func convertDaysToString(days: [Int]) -> String {
    // 요일 데이터 매핑 (Int -> String)
    let dayNames = ["일", "월", "화", "수", "목", "금", "토"]
    
    // 요일 인덱스를 텍스트로 변환
    let dayStrings = days.compactMap { dayIndex -> String? in
        guard dayIndex >= 1 && dayIndex <= 7 else { return nil }
        return dayNames[dayIndex - 1]
    }
    
    // 조건에 따라 텍스트 반환
    if days.contains(1) && days.contains(7) && days.count == 7 {
        return "매일"
    } else if Set([2, 3, 4, 5, 6]).isSubset(of: days) && !days.contains(1) && !days.contains(7) {
        return "평일"
    } else if Set([1, 7]).isSubset(of: days) && days.count == 2 {
        return "주말"
    } else {
        return dayStrings.joined(separator: " ")
    }
}
