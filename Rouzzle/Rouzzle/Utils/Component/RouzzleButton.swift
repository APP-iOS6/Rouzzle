//
//  RouzzleButton.swift
//  Rouzzle
//
//  Created by 김정원 on 11/2/24.
//

import SwiftUI
/// 모든 버튼 유형
enum ButtonType: String {
    case dataIntegration = "데이터 통합"
    case share = "공유하기"
    case agreeAndStart = "동의하고 시작하기"
    case next = "다음"
    case save = "저장"
    case withdraw = "탈퇴하기"
    
    var title: String {
        return self.rawValue
    }
    
    var buttonFont: Font {
        switch self {
        default:
            return Font.system(size: 16.0)
        }
    }
    
    var buttonColor: Color {
        switch self {
        default:
            return Color.red
        }
    }
}

/// 버튼은 type 만을 넘겨주고 동일하게 사용할 수 있도록
struct RouzzleButton: View {
    let buttonType: ButtonType
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text("\(buttonType.title)")
                .foregroundColor(buttonType.buttonColor)
                .font(buttonType.buttonFont)
                .frame(maxWidth: .infinity)
                .frame(height: 48, alignment: .center)
        }
    }
    
}
