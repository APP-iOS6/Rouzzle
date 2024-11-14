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
    @Binding var selectedRecommendTask: [RecommendTodoTask]
    @Binding var allCheckBtn: Bool
    @State private var selectedCardID: UUID?
    let addRoutine: (String, String, RoutineItem?) -> Void
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(cards) { card in
                        if selectedCardID == card.id {
                            RecommendDetailView(
                                card: card,
                                animation: animationNamespace,
                                selectedRecommendTask: $selectedRecommendTask,
                                allCheckBtn: $allCheckBtn
                            ) {
                                withAnimation {
                                    selectedCardID = nil
                                }
                            } addRoutine: { routineItem in
                                addRoutine(card.title, card.imageName, routineItem)
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
            .scrollIndicators(.hidden)
        }
        .animation(.spring(), value: selectedCardID)
        .onChange(of: selectedCardID) { _, _ in
            allCheckBtn = false
            selectedRecommendTask.removeAll()
        }
    }
}

#Preview {
    RecommendCardListView(cards: .constant(DummyCardData.celebrityCards), selectedRecommendTask: .constant([]), allCheckBtn: .constant(false)) { _, _, _ in }
}
