//
//  RouzzleChallengePuzzleView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/15/24.
//

import SwiftUI

struct RouzzleChallengePuzzleView: View {
    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                colors: [.white, Color.fromRGB(r: 252, g: 255, b: 240)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                // 여기에 퍼즐 콘텐츠를 추가할 수 있습니다
                Text("퍼즐 콘텐츠가 들어갈 자리입니다")
                    .padding()
            }
            .customNavigationBar(title: "루즐 퍼즐테스트")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    PieceCounter(count: 9)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RouzzleChallengePuzzleView()
    }
}
