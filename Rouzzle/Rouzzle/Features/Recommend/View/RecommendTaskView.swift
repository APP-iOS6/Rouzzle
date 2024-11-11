//
//  RecommendTaskView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/11/24.
//

import SwiftUI

struct RecommendTaskView: View {
    let task: RoutineTask
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        // 전체 컨테이너를 frame으로 먼저 잡습니다
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.grayultralight)
            
            HStack(spacing: 10) {
                HStack {
                    Text(task.emoji)
                        .font(.title)
                        .frame(width: 40) // 이모지 영역 고정
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(task.title)
                            .font(.headline)
                        Text("\(task.timer)분")
                            .font(.regular12)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Button(action: onTap) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(isSelected ? .accentColor : .graylight)
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 60)
    }
}

#Preview {
    RecommendTaskView(
        task: RoutineTask(title: "아침 스트레칭", emoji: "🙆‍♀️", timer: 15),
        isSelected: false,
        onTap: {}
    )
}
