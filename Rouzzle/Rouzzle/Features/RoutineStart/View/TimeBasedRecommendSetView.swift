//
//  TimeBasedRecommendSetView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/7/24.
//

import SwiftUI

struct TimeBasedRecommendSetView: View {
    @Environment(\.dismiss) private var dismiss
    let category: RoutineCategoryByTime
    let action: ([RecommendTodoTask]) -> Void
    @State var addRecommendTask: [RecommendTodoTask] = []
    @State var allCheckBtn: Bool = false
    @State private var selectedTasks: [String: Bool] = [:]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.subbackgroundcolor)
                    .edgesIgnoringSafeArea(.all)
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .center, spacing: 10) {
                        RecommendTaskByTime(category: category)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 20)
                            .padding(.bottom, 20)
                        
                        ForEach(category.tasks.indices, id: \.self) { index in
                            let task = category.tasks[index]
                            RecommendTask(
                                isPlus: Binding(
                                    get: { addRecommendTask.contains(where: { $0.title == task.title }) },
                                    set: { isSelected in
                                        let recommendTodoTask = RecommendTodoTask(
                                            emoji: task.emoji,
                                            title: task.title,
                                            timer: task.timeInterval
                                        )
                                        if isSelected {
                                            if !addRecommendTask.contains(where: { $0.title == task.title }) {
                                                addRecommendTask.append(recommendTodoTask)
                                            }
                                        } else {
                                            addRecommendTask.removeAll(where: { $0.title == task.title })
                                        }
                                        allCheckBtn = (addRecommendTask.count == category.tasks.count)
                                    }
                                ),
                                emojiTxt: task.emoji,
                                title: task.title,
                                timeInterval: task.timeInterval.formattedTimer,
                                description: task.description
                            ) {
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, index < category.tasks.count - 1 ? 10 : 5)
                        }
                        
                        HStack(spacing: 4) {
                            Spacer()
                            HStack(spacing: 2) {
                                Image(systemName: allCheckBtn ? "checkmark.square.fill" : "square")
                                    .foregroundStyle(allCheckBtn ? Color.accent : Color.gray)
                                Text("전체선택")
                                    .font(.regular12)
                                    .foregroundStyle(.gray)
                            }
                            .onTapGesture {
                                toggleAllTasks()
                            }
                        }
                        .padding(.bottom, 20)
                        .padding(.top, 10)
                        
                        RouzzleButton(buttonType: .addtoroutine) {
                            action(addRecommendTask)
                            dismiss()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                    }
                    .padding(.horizontal, 0)
                    .padding(.bottom, 30)
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.bold24)
                    }
                    .padding()
                }
            }
        }
    }
    
    private func toggleAllTasks() {
        if allCheckBtn {
            allCheckBtn = false
            addRecommendTask.removeAll()
        } else {
            allCheckBtn = true
            addRecommendTask = category.tasks.map {
                RecommendTodoTask(
                    emoji: $0.emoji,
                    title: $0.title,
                    timer: $0.timeInterval
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        TimeBasedRecommendSetView(category: .morning) { _ in }
    }
}
