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
                        RecommendDetailView(card: card, animation: animationNamespace) {
                            selectedCardID = nil
                        }
                    } else {
                        RecommendCardView(card: card, animation: animationNamespace) {
                            selectedCardID = card.id
                        }
                        .padding(.horizontal)
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
