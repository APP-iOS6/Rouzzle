//
//  RecommendViewModel.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/11/24.
//

import Foundation

@Observable
final class RecommendViewModel {
    var selectedCategory: String = "유명인" {
        didSet { updateCards() }
    }

    private let allCards: [String: [Card]] = [
        "유명인": DummyCardData.celebrityCards,
        "아침": DummyCardData.morningCards,
        "저녁": DummyCardData.eveningCards,
        "건강": DummyCardData.healthCards,
        "반려동물": DummyCardData.petCards,
        "생산성": DummyCardData.productivityCards,
        "휴식": DummyCardData.restCards
    ]

    var filteredCards: [Card] = []

    init() {
        updateCards()
    }

    private func updateCards() {
        filteredCards = allCards[selectedCategory] ?? []
    }
}
