//
//  RoutineCompletionOverlay.swift
//  Rouzzle
//
//  Created by 김동경 on 11/20/24.
//

import SwiftUI

struct RoutineCompletionOverlay: View {
    
    let routineCompletion: RoutineCompletion
    let action: () -> Void
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color(.black).opacity(0.5)
                    .ignoresSafeArea(edges: .all)
                    .onTapGesture {
                        action()
                    }
                VStack(spacing: 20) {
                    Text(routineCompletion.date.formattedDateToday)
                        .font(.semibold18)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ForEach(routineCompletion.taskCompletions, id: \.self) { task in
                        HStack {
                            Image(systemName: task.isComplete ? "checkmark.square.fill" : "square")
                                .foregroundStyle(.accent)
                            
                            Text("\(task.emoji) \(task.title)")
                                .font(.regular16)
                            Spacer()
                        }
                    }
                    Text("루틴 종료 시간: \(routineCompletion.date.formattedToTimeDetail)")
                        .font(.regular12)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button {
                        action()
                    } label: {
                        Text("확인")
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .font(.medium16)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
                .frame(maxWidth: proxy.size.width * 0.7)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 10)
            }
        }
    }
}

#Preview {
    RoutineCompletionOverlay(
                             routineCompletion: .init(routineId: "", userId: "", date: Date(),
                                                      taskCompletions: [.init(title: "물먹기", emoji: "😀", timer: 100, isComplete: true),
                                                                        .init(title: "일어나기", emoji: "😀", timer: 200, isComplete: true),
                                                                        .init(title: "테스트하기", emoji: "😀", timer: 20, isComplete: false)])) {
                                                                            
                                                                        }
}
