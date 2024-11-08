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
        
    var status: RoutineStatus {
        return routineItem.taskList.filter {$0.isCompleted}.count == routineItem.taskList.count ? .completed : .pending
    }
    
    var inProgressStr: String {
        let completedTaskCount = routineItem.taskList.filter {$0.isCompleted}.count
        if completedTaskCount == 0 {
            return ""
        }
        return "\(completedTaskCount)/\(routineItem.taskList.count)"
    }
    
    var alramImageName: String {
        routineItem.alarmIDs == nil ? "bell.slash" : "bell"
    }
    
    var isAlram: Bool {
        routineItem.alarmIDs == nil ? false : true
    }
    
    var body: some View {
        ZStack {
            status.image
                .resizable()
                .frame(maxWidth: .infinity)
                .aspectRatio(370/137, contentMode: .fit)
            
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
                        Image(systemName: isAlram ? "bell" : "bell.slash")
                        Text(routineItem.dayStartTime[1, default: ""].to12HourFormattedTime())
                        Text(routineItem.dayStartTime[1, default: ""].to12HourPeriod())
                    }
                    .font(.regular16)
                    Text(convertDaysToStirng(days: routineItem.dayStartTime.keys.sorted()))
                        .font(.regular14)
                }
                .foregroundStyle(Color.subHeadlineFontColor)
            }
            .padding(.horizontal, 20)
            .offset(y: -5)
        }
        .opacity(status == .pending ? 1 : 0.6)
    }
    
    func convertDaysToStirng(days: [Int]) -> String {
        var str = ""
        for day in days {
            str += " \(dayOfWeek[day, default: ""])"
        }
        return str
    }

}

struct RoutineItemSample {
    var title: String = "운동 루틴"
    var emoji: String = "💪🏻"
    var dayStartTime: [Int: String]
    var alarmsIDs: [Int: String]?
    var taskList: [TaskList] = []
}
