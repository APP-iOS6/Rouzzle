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
    
    var status: RoutineStatus
    var emojiText: String = "💪🏻"
    var routineTitle: String = "운동 루틴"
    var inProgressStr: String = "3/5"
    var repeatDay: String = "월  수  금"
    var bellImage: Image = Image(systemName: "bell")
    var routineStartTime: String = "06:30 AM"
    @State var isAlram = false
    
    var body: some View {
        
        ZStack {
            status.image
                .resizable()
                .frame(maxWidth: .infinity)
                .aspectRatio(370/137, contentMode: .fit)
            
            HStack {
                Text("\(emojiText)")
                    .font(.bold40)
                    .padding(.horizontal, 10)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(routineTitle)
                        .font(.semibold20)
                        .foregroundStyle(.black)
                        .bold()
                        .strikethrough(status == .completed)
                    
                    Text(inProgressStr)
                        .font(.regular14)
                        .foregroundStyle(Color.subHeadlineFontColor)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    HStack {
                        Image(systemName: isAlram ? "bell" : "bell.slash")
                        Text(routineStartTime)
                    }
                    .font(.regular16)
                    Text(repeatDay)
                        .font(.regular14)
                }
                .foregroundStyle(Color.subHeadlineFontColor)
            }
            .padding(.horizontal, 20)
            .offset(y: -5)
        }
        .opacity(status == .pending ? 1 : 0.6)
    }
    
}

#Preview {
    RoutineStatusPuzzle(status: .pending)
}

struct RoutineStatusPuzzle2: View {
    
   // @Query private var routineItem: RoutineItem
   // @Environment(\.modelContext) private var modelContext
    
    var routineItem: RoutineItemSample = RoutineItemSample(title: "운동 루틴", emoji: "💪🏻", dayStartTime: [1: "06:30"], taskList: [TaskList(title: "밥 먹기", emoji: "🍚", timer: 3),
                                                                                                                                 TaskList(title: "양치하기", emoji: "🪥", timer: 3, isCompleted: true )])
    
    var status: RoutineStatus { // tasklist의 완료 여부를 비교해서 이미지를 다르게 띄움
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
        routineItem.alarmsIDs == nil ? "bell.slash" : "bell"
    }
    
    var isAlram: Bool {
        return routineItem.alarmsIDs == nil ? false : true
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
                    Text("월  수  금")
                        .font(.regular14)
                }
                .foregroundStyle(Color.subHeadlineFontColor)
            }
            .padding(.horizontal, 20)
            .offset(y: -5)
        }
        .opacity(status == .pending ? 1 : 0.6)
    }
}

#Preview("2") {
    RoutineStatusPuzzle2()
}

struct RoutineItemSample {
    var title: String = "운동 루틴"
    var emoji: String = "💪🏻"
    var dayStartTime: [Int: String]
    var alarmsIDs: [Int: String]?
    var taskList: [TaskList] = []
}
