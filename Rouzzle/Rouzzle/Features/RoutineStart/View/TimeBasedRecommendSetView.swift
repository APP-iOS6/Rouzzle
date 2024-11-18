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
                    VStack(alignment: .center, spacing: 30) {
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
                                        if isSelected {
                                            let recommendTodoTask = RecommendTodoTask(
                                                emoji: task.emoji,
                                                title: task.title,
                                                timer: task.timeInterval
                                            )
                                            addRecommendTask.append(recommendTodoTask)
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
                                let recommendTodoTask = RecommendTodoTask(
                                    emoji: task.emoji,
                                    title: task.title,
                                    timer: task.timeInterval
                                )
                                if addRecommendTask.contains(where: { $0.title == recommendTodoTask.title }) {
                                    addRecommendTask.removeAll(where: { $0.title == recommendTodoTask.title })
                                } else {
                                    addRecommendTask.append(recommendTodoTask)
                                }
                                
                                allCheckBtn = (addRecommendTask.count == category.tasks.count)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, index < category.tasks.count - 1 ? 25 : 0)
                        }
                        
                        HStack {
                            Spacer()
                            HStack {
                                Image(systemName: allCheckBtn ? "checkmark.square.fill" : "square")
                                    .foregroundColor(allCheckBtn ? .accentColor : .gray)
                                Text("전체선택")
                                    .font(.regular16)
                                    .foregroundColor(.gray)
                            }
                            .onTapGesture {
                                toggleAllTasks()
                            }
                        }
                        .padding(.bottom, 20)

                        RouzzleButton(buttonType: .save) {
                            action(addRecommendTask)
                            dismiss()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                    }
                    .padding(.horizontal, 0)
                    .padding(.bottom, 30)
                }
                .customNavigationBar(title: "추천 세트")
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
