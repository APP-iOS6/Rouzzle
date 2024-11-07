//
//  TimeBasedRecommendSetView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/7/24.
//

import SwiftUI

struct TimeBasedRecommendSetView: View {
    let category: RoutineCategoryByTime // 카테고리 아침, 오후, 저녁, 휴식을 전달받음
    
    var body: some View {
        ZStack {
            Color("OnBoardingBackgroundColor")
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
                                timeInterval: category.tasks[index].timeInterval,
                                isPlus: false,
                                description: category.tasks[index].description
                            )
                            
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
                        print("저장하기")
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

#Preview {
    NavigationStack {
        TimeBasedRecommendSetView(category: .morning)
    }
}