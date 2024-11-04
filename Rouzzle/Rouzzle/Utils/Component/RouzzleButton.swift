//
//  RouzzleButton.swift
//  Rouzzle
//
//  Created by 김정원 on 11/2/24.
//

import SwiftUI
/// 모든 버튼 유형
enum ButtonType: String {
    case addTask = "할일 추가"
    case refreshRecommendations = "추천 새로고침"
    case save = "저장하기"
    case complete = "완료"
}

/// 버튼은 type 만을 넘겨주고 동일하게 사용할 수 있도록
struct RouzzleButton: View {
    let buttonType: ButtonType
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text("\(buttonType.rawValue)")
                .font(.bold20)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: 61)
                .background(.button)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal)
    }
    
}
