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
    let action: () -> Void
    var body: some View {
        ZStack {
            Image(.recommendTaskTimeSet)
                .resizable()
                .frame(maxWidth: .infinity)
                .aspectRatio(370/164.24, contentMode: .fit)
                .shadow(color: .black.opacity(0.1), radius: 2)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(emojiTxt)
                        .font(.bold40)
                    
                    Text(title)
                        .font(.semibold20)
                        .padding(.horizontal, 10)
                    
                    Text(timeInterval)
                        .font(.regular12)
                        .foregroundStyle(Color.subHeadlineFontColor)
                    
                    Spacer()
                    
                    Button {
                        isPlus.toggle()
                        action()
                    } label: {
                        Image(systemName: isPlus ? "plus.circle.fill" : "circle.dotted")
                            .foregroundStyle(.accent)
                            .font(.title)
                    }
                }
                .padding(.bottom, 3)
                
                Text(description)
                    .font(.light14)
                    .frame(maxWidth: .infinity, alignment: .leading) // 고정 너비 대신 maxWidth 사용
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
            }
            .padding()
        }
        
    }
}

#Preview {
    RecommendTask {
        
    }
}
