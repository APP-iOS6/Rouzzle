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
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.grayultralight)
            
            HStack(spacing: 10) {
                HStack {
                    Text(task.emoji)
                        .font(.title)
                        .frame(width: 40)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(task.title)
                            .font(.headline)
                        Text("\(task.timer.formattedTimer)")
                            .font(.regular12)
                            .foregroundStyle(.gray)
                    }
                }
                
                Spacer()
                
                Button(action: onTap) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(isSelected ? .accent : .graylight)
                }
            }
            .padding(.horizontal)
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
