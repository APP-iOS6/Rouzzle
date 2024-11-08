//
//  RoutineState.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import Foundation
import SwiftUI

enum TaskStatus {
    case pending
    case inProgress
    case completed
    case recommend
    
    var image: Image {
        switch self {
        case .pending:
            Image(.pendingTask)
        case .inProgress:
            Image(.inProgressTask)
        case .completed:
            Image(.completedTask)
        case .recommend:
            Image(.recommendTask)
        }
    }
}

struct TaskStatusPuzzle: View {
    @Bindable var task: TaskList
    
    var taskStatus: TaskStatus {
        task.isCompleted ? .completed : .pending
    }
    
    var body: some View {
        ZStack {
            taskStatus.image
                .resizable()
                .frame(maxWidth: .infinity)
                .aspectRatio(370/105, contentMode: .fit)
                .shadow(color: taskStatus == .pending ? .black.opacity(0.1) : .clear, radius: 2)
            
            HStack {
                Text(task.emoji)
                    .font(.bold40)
                    .padding(.leading, 25)
                
                HStack(spacing: 10) {
                    Text(task.title)
                        .font(.semibold18)
                        .lineLimit(1)
                    
                    if taskStatus == .recommend {
                        Text("\(task.timer)분")
                            .font(.regular12)
                            .foregroundColor(Color.subHeadlineFontColor)
                    }
                }
                .padding(.horizontal, 7)
                .overlay {
                    taskStatus == .completed ?
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.gray)
                    : nil
                }
                
                Spacer()
                
                if taskStatus == .recommend {
                    Image(systemName: "plus")
                        .foregroundColor(Color.subHeadlineFontColor)
                        .font(.title2)
                        .padding(.trailing, 25)
                } else {
                    Text("\(task.timer)분")
                        .font(.regular14)
                        .foregroundColor(Color.subHeadlineFontColor)
                        .padding(.trailing, 25)
                }
            }
            .offset(y: -5)
        }
        .opacity(taskStatus == .completed ? 0.7 : 1)
    }
}

// TaskListSheet에서 쓰이는 컴포넌트
struct TaskStatusRow: View {
    private(set) var taskStatus: TaskStatus
    private(set) var emojiText: String = "💊"
    private(set) var title: String = "유산균 먹기"
    private(set) var timeInterval: Int? = 60
    
    @Binding var showEditIcon: Bool // 리스트 수정일 때 보이는 아이콘
    
    private var backgroundColor: Color {
        switch taskStatus {
        case .completed:
            return Color.fromRGB(r: 248, g: 247, b: 247)
        case .inProgress:
            return Color.fromRGB(r: 252, g: 255, b: 240)
        case .pending:
            return .white
        default:
            return .white
        }
        
    }
    
    var body: some View {
        HStack {
            Text(emojiText)
                .font(.bold30)
            
            Text(title)
                .font(.semibold16)
                .strikethrough(taskStatus == .completed)
            
            Spacer()
            
            if let timeInterval = timeInterval {
                Text(timeInterval >= 60 ? "\(timeInterval / 60)분" : "\(timeInterval)초")
                    .font(.regular14)
                    .foregroundStyle(Color.subHeadlineFontColor)
            } else {
                Text("지속 시간 없음")
                    .font(.regular14)
                    .foregroundStyle(Color.subHeadlineFontColor)
            }
            
            if showEditIcon {
                Image(.listEditIcon)
                    .foregroundStyle(Color.subHeadlineFontColor)
                    .padding(.leading, 10)
            }
        }
        .opacity(taskStatus == .completed ? 0.5 : 1.0)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(backgroundColor)
                .stroke(
                    taskStatus == .inProgress ? Color.themeColor.opacity(0.3) : Color.clear, // inProgress일 때만 테두리
                    lineWidth: taskStatus == .inProgress ? 2 : 0
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 2)
    }
}

#Preview("TaskStatusRow") {
    TaskStatusRow(taskStatus: .pending, showEditIcon: .constant(false))
}
