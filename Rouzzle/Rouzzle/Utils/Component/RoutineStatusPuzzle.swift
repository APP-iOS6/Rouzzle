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
    
    @Bindable var routineItem: RoutineItem
    @Environment(\.modelContext) private var modelContext
    
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
                    .padding(.horizontal, 10)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(routineItem.title)
                        .font(.semibold20)
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
                    .font(.regular16)
                    Text(convertDaysToString(days: routineItem.dayStartTime.keys.sorted()))
                        .font(.regular14)
                }
                .foregroundStyle(Color.subHeadlineFontColor)
            }
            .padding(.horizontal, 20)
            .offset(y: -5)
        }
        .opacity(status == .pending ? 1 : 0.6)
    }
    
    func convertDaysToString(days: [Int]) -> String {
        var str = ""
        for day in days {
            str += " \(dayOfWeek[day, default: ""])"
        }
        return str
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
