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
        HStack(spacing: 10) {
            HStack {
                Text(task.emoji)
                    .font(.title)
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
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.grayultralight)
        )
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
