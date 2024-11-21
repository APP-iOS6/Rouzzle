//
//  RoutinePuzzle.swift
//  Rouzzle
//
//  Created by 김정원 on 11/3/24.
//

import SwiftUI
import SwiftData

enum RoutineStatus {
    case pending
    case completed
    
    var image: Image {
        switch self {
        case .pending:
            Image(.pendingRoutine)
        case .completed:
            Image(.completedRoutine)
        }
    }
}

struct RoutineStatusPuzzle: View {
    
    var routineItem: RoutineItem
    
    var todayStartTime: String {
        let today = Date()
        let calendar = Calendar.current
        let weekdayNumber = calendar.component(.weekday, from: today)
        let value = routineItem.dayStartTime[weekdayNumber] ?? routineItem.dayStartTime.first?.value ?? ""
        return value.to12HourPeriod() + " " + value.to12HourFormattedTime()
    }
    
    var status: RoutineStatus {
        return ((routineItem.taskList.filter { $0.isCompleted }.count == routineItem.taskList.count) && !routineItem.taskList.isEmpty) ? .completed : .pending
    }
    
    var inProgressStr: String {
        let completedTaskCount = routineItem.taskList.filter { $0.isCompleted }.count
        if completedTaskCount == 0 {
            return ""
        }
        return "\(completedTaskCount)/\(routineItem.taskList.count)"
    }
    
    var alarmImageName: String {
        // 알림 ID가 존재하고 값이 비어있지 않은 경우 알림 활성화로 표시
        if let alarmIDs = routineItem.alarmIDs, !alarmIDs.isEmpty {
            return "bell"
        } else {
            return "bell.slash"
        }
    }
    
    var body: some View {
        ZStack {
            status.image
                .resizable()
                .frame(maxWidth: .infinity)
                .aspectRatio(370 / 137, contentMode: .fit)
            
            HStack {
                Text("\(routineItem.emoji)")
                    .font(.bold40)
                    .padding(.trailing, 10)
                    .padding(.bottom, 7)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(routineItem.title)
                        .font(.semibold18)
                        .foregroundStyle(.black)
                        .bold()
                        .strikethrough(status == .completed)
                    
                    Text(inProgressStr)
                        .font(.regular14)
                        .foregroundStyle(Color.subHeadlineFontColor)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    HStack(spacing: 5) {
                        Image(systemName: alarmImageName) // 알림 이미지 동적으로 업데이트
                        Text(todayStartTime)
                    }
                    .font(.regular14)
                    Text(convertDaysToString(days: routineItem.dayStartTime.keys.sorted()))
                        .font(.regular14)
                }
                .foregroundStyle(Color.subHeadlineFontColor)
            }
            .padding(.horizontal, 20)
            .offset(y: -7)
        }
        .opacity(status == .pending ? 1 : 0.6)
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
}

// #Preview("2") {
//    RoutineStatusPuzzle2()
// }

struct RoutineItemSample {
    var title: String = "운동 루틴"
    var emoji: String = "💪🏻"
    var dayStartTime: [Int: String]
    var alarmsIDs: [Int: String]?
    var taskList: [TaskList] = []
}
