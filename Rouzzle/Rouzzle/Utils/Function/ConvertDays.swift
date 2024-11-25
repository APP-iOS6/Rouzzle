//
//  ConvertDays.swift
//  Rouzzle
//
//  Created by 김정원 on 11/9/24.
//

import Foundation

let dayOfWeek: [Int: String] = [
    1: "일", 2: "월", 3: "화", 4: "수", 5: "목", 6: "금", 7: "토"
]
func getRoutineTimeRangeString(routine: Routine) -> String {
    // 오늘의 요일 가져오기 (1: 일요일, ..., 7: 토요일)
    let todayWeekday = Calendar.current.component(.weekday, from: Date())
    
    // 시작 시간 결정
    var startTime: Date?
    if let startTimeString = routine.dayStartTime[todayWeekday],
       let date = getDateFromTimeString(startTimeString) {
        startTime = date
    } else if let anyStartTimeString = routine.dayStartTime.values.first,
              let date = getDateFromTimeString(anyStartTimeString) {
        startTime = date
    } else {
        // 시작 시간이 없을 경우 빈 문자열 반환
        return ""
    }
    
    // 총 소요 시간 계산 (초 단위)
    let totalDurationInSeconds = routine.routineTask.reduce(0) { $0 + $1.timer }
    
    // 종료 시간 계산
    let endTime = startTime!.addingTimeInterval(TimeInterval(totalDurationInSeconds))
    
    // 시간 형식화
    let displayFormatter = DateFormatter()
    displayFormatter.dateFormat = "h:mm a"
    displayFormatter.amSymbol = "AM"
    displayFormatter.pmSymbol = "PM"
    
    let startTimeStringFormatted = displayFormatter.string(from: startTime!)
    let endTimeStringFormatted = displayFormatter.string(from: endTime)
    
    return "\(startTimeStringFormatted) ~ \(endTimeStringFormatted)"
}

func getDateFromTimeString(_ timeString: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    formatter.locale = Locale(identifier: "ko_KR")
    
    if let date = formatter.date(from: timeString) {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        let now = Date()
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: date)
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        return calendar.date(from: components)
    }
    return nil
}
