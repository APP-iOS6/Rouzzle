//
//  RoutineState.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import Foundation
import SwiftUI
import SwiftData

enum TaskStatus {
    case pending
    case inProgress
    case completed
    
    var image: Image {
        switch self {
        case .pending:
            Image(.pendingTask)
        case .inProgress:
            Image(.inProgressTask)
        case .completed:
            Image(.completedTask)
        }
    }
}
struct RecommendTodoTask: Hashable {
    let emoji: String
    let title: String
    let timer: Int // 분 단위
    
    func toTaskList() -> TaskList {
        return TaskList(title: title, emoji: emoji, timer: timer)
    }
    
    func toRoutineTask() -> RoutineTask {
        return RoutineTask(title: title, emoji: emoji, timer: timer)
    }
}

struct TaskStatusPuzzle: View {
    @Bindable var task: TaskList
    
    var taskStatus: TaskStatus {
        task.isCompleted ? .completed : .pending
    }
    
    var body: some View {
        HStack {
            Text(task.emoji)
                .font(.bold40)
                .padding(.leading, 25)
            
            HStack(spacing: 10) {
                Text(task.title)
                    .font(.semibold18)
                    .strikethrough(taskStatus == .completed)
                    .lineLimit(1)
            }
            .padding(.horizontal, 7)
            
            Spacer()
            
            Text(task.timer.formattedTimer)
                .font(.regular14)
                .foregroundColor(Color.subHeadlineFontColor)
                .padding(.trailing, 25)
            
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(style: StrokeStyle(lineWidth: 1))
                .foregroundStyle(.grayborderline)
        }
        .opacity(taskStatus == .completed ? 0.7 : 1)
    }
}

struct AddTaskPuzzle: View {
    var task: RoutineTask
    
    var body: some View {
        HStack {
            Text(task.emoji)
                .font(.bold40)
                .padding(.leading, 25)
            
            HStack(spacing: 10) {
                Text(task.title)
                    .font(.semibold18)
                    .lineLimit(1)
            }
            .padding(.horizontal, 7)
            
            Spacer()
            
            Text(task.timer.formattedTimer)
                .font(.regular14)
                .foregroundColor(Color.subHeadlineFontColor)
                .padding(.trailing, 25)
            
        }
        .padding(.vertical, 8)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(style: StrokeStyle(lineWidth: 1))
                .foregroundStyle(.gray)
        )
    }
}

let recommendTodoTask: [RecommendTodoTask] = [
    RecommendTodoTask(emoji: "🧘", title: "명상하기", timer: 10),
    RecommendTodoTask(emoji: "🏋️‍♂️", title: "가벼운 운동하기", timer: 15),
    RecommendTodoTask(emoji: "🍵", title: "차 한 잔 마시기", timer: 5),
    RecommendTodoTask(emoji: "📖", title: "책 읽기", timer: 20),
    RecommendTodoTask(emoji: "🌞", title: "산책하기", timer: 15),
    RecommendTodoTask(emoji: "📝", title: "점심 계획 세우기", timer: 5),
    RecommendTodoTask(emoji: "🎧", title: "좋아하는 음악 듣기", timer: 15),
    RecommendTodoTask(emoji: "🍽", title: "요리하기", timer: 30),
    RecommendTodoTask(emoji: "🛋", title: "휴식하기", timer: 20),
    RecommendTodoTask(emoji: "📓", title: "오늘 하루 정리하기", timer: 10),
    RecommendTodoTask(emoji: "🛀", title: "반신욕하기", timer: 20),
    RecommendTodoTask(emoji: "🌙", title: "수면 준비하기", timer: 15)
]

struct TaskRecommendPuzzle: View {
    var recommendTask: RecommendTodoTask
    var onAddTap: () -> Void
    var body: some View {
        HStack {
            Text(recommendTask.emoji)
                .font(.bold40)
                .padding(.leading, 25)
            
            HStack(spacing: 10) {
                Text(recommendTask.title)
                    .font(.semibold18)
                    .lineLimit(1)
                
                Text(recommendTask.timer.formattedTimer)
                    .font(.regular12)
                    .foregroundColor(Color.subHeadlineFontColor)
                
            }
            .padding(.horizontal, 7)
            
            Spacer()
            
            Button {
                onAddTap()
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(Color.subHeadlineFontColor)
                    .font(.title2)
                    .padding(.trailing, 25)
                
            }
        }
        .padding(.vertical, 8)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [10, 5]))
                .foregroundStyle(.grayborderline)
        )
        
    }
}

// TaskListSheet에서 쓰이는 컴포넌트
struct TaskStatusRow: View {
    private(set) var taskStatus: TaskStatus
    private(set) var emojiText: String = "💊"
    private(set) var title: String = "유산균 먹기"
    private(set) var timeInterval: Int?
    
    @Binding var showEditIcon: Bool // 리스트 수정일 때 보이는 아이콘
    @Binding var showDeleteIcon: Bool // 리스트 삭제할 때 보이는 버튼
    
    var onDelete: (() -> Void)? // 삭제 클로저
    
    @State private var showDeleteConfirmation = false
    
    private var backgroundColor: Color {
        switch taskStatus {
        case .completed:
            return Color.fromRGB(r: 248, g: 247, b: 247)
        case .inProgress:
            return Color.fromRGB(r: 252, g: 255, b: 240)
        case .pending:
            return .white
        }
    }
    
    var body: some View {
        HStack {
            Text(emojiText)
                .font(.bold40)
                .padding(.horizontal, 8)
            
            Text(title)
                .font(.semibold18)
                .strikethrough(taskStatus == .completed)
                .padding(.trailing, 12)
            
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
            
            // 삭제하기 버튼
            if showDeleteIcon {
                Button {
                    showDeleteConfirmation = true
                } label: {
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(.red)
                        .padding(.leading, 10)
                }
                .alert(isPresented: $showDeleteConfirmation) {
                    Alert(
                        title: Text("삭제하시겠습니까?"),
                        message: Text("이 작업은 되돌릴 수 없습니다."),
                        primaryButton: .destructive(Text("삭제")) {
                            onDelete?()
                        },
                        secondaryButton: .cancel(Text("취소"))
                    )
                }
            }
        }
        .opacity(taskStatus == .completed ? 0.5 : 1.0)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(backgroundColor)
                .stroke(
                    taskStatus == .inProgress ? Color.themeColor.opacity(0.3) : .grayborderline, // inProgress일 때만 테두리
                    lineWidth: 1
                )
        )
    }
}

#Preview("TaskStatusRow") {
    TaskStatusRow(taskStatus: .pending, showEditIcon: .constant(false), showDeleteIcon: .constant(false))
}
