//
//  TaskListSheet.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/7/24.
//

import SwiftUI

struct TaskListSheet: View {
    var body: some View {
        VStack(spacing: 35) {
            Text("할일 목록")
                .font(.semibold20)
            
            VStack(spacing: 10) {
                TaskStatusPuzzle(taskStatus: .completed, emojiText: "☕️", title: "커피/차 마시기")
                
                TaskStatusPuzzle(taskStatus: .inProgress, emojiText: "💊", title: "유산균 먹기")
                
                TaskStatusPuzzle(taskStatus: .pending, emojiText: "🧼", title: "설거지 하기")
                
                TaskStatusPuzzle(taskStatus: .pending, emojiText: "👕", title: "옷 갈아입기")
            }
            
            Button {
                
            } label: {
                Text("순서 수정")
                    .underline()
                    .font(.regular18)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    TaskListSheet()
}
