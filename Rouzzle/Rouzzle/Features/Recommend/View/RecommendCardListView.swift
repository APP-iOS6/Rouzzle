//
//  RecommendCardListView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/11/24.
//

import SwiftUI

struct RecommendCardListView: View {
    @Namespace private var animationNamespace
    @Binding var cards: [Card]
    @State private var selectedCardID: UUID?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(cards) { card in
                    if selectedCardID == card.id {
                        // 카드 확장 뷰
//                        ExpandedCardView(card: card, animation: animationNamespace) {
//                            selectedCardID = nil
//                        }
                    } else {
                        // 카드 축소 뷰
                        RecommendCardView(card: card, animation: animationNamespace) {
                            selectedCardID = card.id
                        }
                        .padding(.horizontal, 16) // 양옆 패딩 추가
                    }
                }
            }
        }
        .animation(.spring(), value: selectedCardID)
    }
}

#Preview {
    RecommendCardListView(cards: .constant(DummyCardData.celebrityCards))
}
