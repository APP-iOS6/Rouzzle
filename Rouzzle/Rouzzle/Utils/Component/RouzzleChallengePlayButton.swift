//
//  RouzzleChallengePlayButton.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/12/24.
//

import SwiftUI

struct RouzzleChallengePlayButton: View {
   enum ButtonStyle {
       case small // 작은이미지용 버튼
       case large // 메인 이미지용 버튼
       
       var width: CGFloat {
           switch self {
           case .small: return 50
           case .large: return 87
           }
       }
       
       var height: CGFloat {
           switch self {
           case .small: return 25
           case .large: return 41
           }
       }
       
       var font: Font {
           switch self {
           case .small: return .bold14
           case .large: return .bold24
           }
       }
   }
   
   let style: ButtonStyle
   let action: () -> Void
   
   init(style: ButtonStyle, action: @escaping () -> Void = {}) {
       self.style = style
       self.action = action
   }
   
    var body: some View {
        NavigationLink(destination: RouzzleChallengePuzzleView()) {
            Text("PLAY")
                .font(style.font)
                .foregroundStyle(.white)
                .frame(width: style.width, height: style.height)
                .background(Color.themeColor)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        RouzzleChallengePlayButton(style: .small)
        RouzzleChallengePlayButton(style: .large)
    }
}
