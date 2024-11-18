//
//  RecommendTask.swift
//  Rouzzle
//
//  Created by 김정원 on 11/6/24.
//

import SwiftUI

struct RecommendTask: View {
    @Binding var isPlus: Bool
    @State var emojiTxt: String = "🧘🏻‍♀️️"
    @State var title: String = "명상하기"
    @State var timeInterval: String = "10분"
    @State var description: String = "명상을 하는 이유는 현재 상황을 직시하고, 사소한 일에 예민하게 반응하지 않고, 침착한 태도를 유지하는 데 도움이 돼요."
    let action: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 2)
                .padding(.horizontal, 2)
            
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
                        Image(systemName: isPlus ? "checkmark.circle.fill" : "plus.circle.fill")
                            .foregroundStyle(isPlus ? .accent : .graylight)
                            .font(.system(size: 24))
                    }
                }
                .padding(.bottom, 3)
                
                Text(description)
                    .font(.light14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 164)
    }
}

#Preview {
    RecommendTask(isPlus: .constant(true)) {
    }
}
