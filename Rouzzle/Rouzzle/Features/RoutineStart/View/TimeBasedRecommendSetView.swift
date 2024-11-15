//
//  TimeBasedRecommendSetView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/7/24.
//

import SwiftUI

struct TimeBasedRecommendSetView: View {
    @Environment(\.dismiss) private var dismiss
    let category: RoutineCategoryByTime // 카테고리 아침, 오후, 저녁, 휴식을 전달받음
    let action: ([RecommendTodoTask]) -> Void
    @State var addRecommendTask: [RecommendTodoTask] = []
    var body: some View {
        NavigationStack {
            ZStack {
                Color("subbackgroundcolor")
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .center, spacing: 8) {
                        RecommendTaskByTime(category: category)
                            .frame(width: 370)
                            .padding(.top, 20)
                        
                        DashedVerticalLine()
                            .frame(maxHeight: 40)
                            .padding(.vertical, 5)
                        
                        ForEach(category.tasks.indices, id: \.self) { index in
                            VStack {
                                RecommendTask(
                                    emojiTxt: category.tasks[index].emoji,
                                    title: category.tasks[index].title,
                                    timeInterval: category.tasks[index].timeInterval.formattedTimer,
                                    isPlus: false,
                                    description: category.tasks[index].description
                                ) {
                                    let recommendTodoTask = RecommendTodoTask(emoji: category.tasks[index].emoji, title: category.tasks[index].title, timer: category.tasks[index].timeInterval)
                                    if addRecommendTask.contains(where: { $0.title == recommendTodoTask.title}) {
                                        addRecommendTask.removeAll(where: { $0.title == recommendTodoTask.title })
                                    } else {
                                        addRecommendTask.append(recommendTodoTask)
                                    }
                                }
                                
                                if index < category.tasks.count - 1 {
                                    DashedVerticalLine()
                                        .frame(maxHeight: 40)
                                        .padding(.vertical, 5)
                                }
                            }
                            .frame(width: 370)
                        }
                        
                        Spacer()
                        
                        RouzzleButton(buttonType: .save) {
                            action(addRecommendTask)
                            dismiss()
                        }
                        .frame(width: 370)
                        .padding(.vertical, 20)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 30)
                    .customNavigationBar(title: "추천 세트")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TimeBasedRecommendSetView(category: .morning) { _ in}
    }
}
