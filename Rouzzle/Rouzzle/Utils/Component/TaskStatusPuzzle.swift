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
            HStack {
                Text("\(emojiText)")
                    .font(.title2)
                    .padding(.leading, 25)
                Text("\(title)")
                    .font(.semibold16)
                    .lineLimit(1)
                    .padding(.horizontal, 7)
                Spacer()
                Text("\(timeIntervel)")
                    .font(.regular14)
                    .foregroundStyle(Color.subHeadlineFontColor)
                    .padding(.trailing, 25)
            }
            .offset(y: -10)
        }
        .opacity(taskStatus == .completed ? 0.7 : 1)
    }
}

#Preview {
    TaskStatusPuzzle(taskStatus: .inProgress)
}
