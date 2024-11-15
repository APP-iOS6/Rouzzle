//
//  RouzzleChallengePuzzleView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/15/24.
//

import SwiftUI

struct RouzzleChallengePuzzleView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            HStack {
                Text("퍼즐 콘텐츠가 들어갈 자리")
            }
        }
        .customNavigationBar(title: "루즐 퍼즐테스트")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                PieceCounter(count: 9)
            }
        }
    }
}

#Preview {
    NavigationStack {
        RouzzleChallengePuzzleView()
    }
}
