//
//  RouzzleButton.swift
//  Rouzzle
//
//  Created by 김정원 on 11/2/24.
//

import SwiftUI
/// 모든 버튼 유형
enum ButtonType: String {
    case start = "시작하기"
    case addTask = "할일 추가"
    case refreshRecommendations = "추천 새로고침"
    case save = "저장하기"
    case complete = "완료"
    
    var title: String {
        return self.rawValue
    }
}

/// 버튼은 type 만을 넘겨주고 동일하게 사용할 수 있도록
struct RouzzleButton: View {
    let buttonType: ButtonType
    let action: () -> Void
    var body: some View {
        GeometryReader { proxy in
            Button(action: action) {
                Text("\(buttonType.title)")
                    .font(.semibold16)
                    .foregroundStyle(Color.white)
                    .background(Color.button)
            }
            .frame(width: proxy.size.width )
        }

        
    }
}
#Preview("dd") {
    Pre()
}
#Preview {
    RouzzleButton(buttonType: .addTask){}
}

struct Pre: View {
    var body: some View {
        RouzzleButton(buttonType: .addTask, action: {})
    }
}
