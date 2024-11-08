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
    // 앞으로 모델이 어떻게 될 지 몰라 하드코딩으로 넣었습니다.
    private(set) var taskStatus: TaskStatus
    private(set) var emojiText: String = "💊"
    private(set) var title: String = "유산균 먹기"
    private(set) var timeIntervel: String = "5분"
    
    var body: some View {
        ZStack {
            taskStatus.image
                .resizable()
                .frame(maxWidth: .infinity)
                .aspectRatio(370/105, contentMode: .fit)
                .shadow(color: taskStatus == .pending ? .black.opacity(0.1) : .clear, radius: 2)
            HStack {
                Text("\(emojiText)")
                    .font(.bold40)
                    .padding(.leading, 25)
                HStack(spacing: 10) {
                    Text("\(title)")
                        .font(.semibold18)
                        .lineLimit(1)
                    
                    if taskStatus == .recommend {
                        Text("\(timeIntervel)")
                            .font(.regular12)
                            .foregroundStyle(Color.subHeadlineFontColor)
                    }
                }
                .padding(.horizontal, 7)
                .overlay {
                    taskStatus == .completed ?
                    Rectangle()
                        .frame(height: 2)
                        .foregroundStyle(.gray)
                    : nil
                }
                Spacer()
                if taskStatus == .recommend {
                    Image(systemName: "plus")
                        .foregroundStyle(Color.subHeadlineFontColor)
                        .font(.title2)
                        .padding(.trailing, 25)
                    
                } else {
                    Text("\(timeIntervel)")
                        .font(.regular14)
                        .foregroundStyle(Color.subHeadlineFontColor)
                        .padding(.trailing, 25)
                }
            }
            .offset(y: -10)
        }
        .opacity(taskStatus == .completed ? 0.7 : 1)
    }
}

// TaskListSheet에서 쓰이는 컴포넌트
struct TaskStatusRow: View {
    private(set) var taskStatus: TaskStatus
    private(set) var emojiText: String = "💊"
    private(set) var title: String = "유산균 먹기"
    private(set) var timeInterval: String = "5분"
    
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
            
            Text(timeInterval)
                .font(.regular14)
                .foregroundStyle(Color.subHeadlineFontColor)
            
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
                    taskStatus == .inProgress ? Color.themeColor.opacity(0.3) : Color.clear, // inProgress일 때만 테두리
                    lineWidth: taskStatus == .inProgress ? 2 : 0
                )
            )
        .shadow(color: .black.opacity(0.1), radius: 2)
    }
}

#Preview {
    TaskStatusPuzzle(taskStatus: .pending)
}

#Preview("TaskStatusRow") {
    TaskStatusRow(taskStatus: .pending, showEditIcon: .constant(false), showDeleteIcon: .constant(false))
}
