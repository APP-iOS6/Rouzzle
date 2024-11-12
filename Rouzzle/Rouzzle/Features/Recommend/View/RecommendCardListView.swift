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
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(cards) { card in
                        if selectedCardID == card.id {
                            RecommendDetailView(card: card, animation: animationNamespace) {
                                withAnimation {
                                    selectedCardID = nil
                                }
                            }
                            .id(card.id)
                        } else {
                            RecommendCardView(card: card, animation: animationNamespace) {
                                withAnimation {
                                    selectedCardID = card.id
                                    // 선택된 카드로 스크롤
                                    proxy.scrollTo(card.id, anchor: .top)
                                }
                            }
                            .id(card.id)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 300)
            }
        }
        .animation(.spring(), value: selectedCardID)
    }
}

#Preview {
    RecommendCardListView(cards: .constant(DummyCardData.celebrityCards))
}
