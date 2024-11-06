//
//  RecommendTask.swift
//  Rouzzle
//
//  Created by 김정원 on 11/6/24.
//

import SwiftUI

struct RecommendTask: View {
    @State var emojiTxt: String = "🧘🏻‍♀️️"
    @State var title: String = "명상하기"
    @State var timeInterval: String = "10분"
    @State var isPlus: Bool = true
    @State var description: String = "명상을 하는 이유는 현재 상황을 직시하고, 사소한 일에 예민하게 반응하지 않고, 침착한 태도를 유지하는 데 도움이 돼요."

    var body: some View {
        ZStack {
            Image(.recommendTask2)
                .resizable()
                .frame(maxWidth: .infinity)
                .aspectRatio(370/164, contentMode: .fit)
                .shadow(color: .black.opacity(0.1), radius: 2)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(emojiTxt)
                        .font(.bold40)
                    
                    Text(title)
                        .font(.semibold20)
                        .padding(.horizontal, 10)
                    
                    Text(timeInterval)
                        .font(.regular14)
                        .foregroundStyle(Color.subHeadlineFontColor)
                    
                    Spacer()
                    
                    Button {
                        // 버튼 액션
                    } label: {
                        Image(systemName: isPlus ? "plus.circle.fill" : "circle.dotted")
                            .foregroundStyle(.accent)
                            .font(.title)
                    }
                }
                .padding(.bottom, 3)
                
                Text(description)
                    .font(.regular14)
                    .lineSpacing(4)
            }
            .padding()
        }
        
    }
}

#Preview {
    RecommendTask()
}
