//
//  RecommendViewModel.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/11/24.
//

import Foundation

@Observable
final class RecommendViewModel {
    enum Category: String, CaseIterable {
        case celebrity = "유명인"
        case morning = "아침"
        case evening = "저녁"
        case health = "건강"
        case pet = "반려동물"
        case productivity = "생산성"
        case rest = "휴식"
    }
    
    var selectedCategory: Category = .celebrity {
        didSet {
            updateCards()
        }
    }
    
    var filteredCards: [Card] = []
    
    private let allCards: [Category: [Card]] = [
        .celebrity: DummyCardData.celebrityCards,
        .morning: DummyCardData.morningCards,
        .evening: DummyCardData.eveningCards,
        .health: DummyCardData.healthCards,
        .pet: DummyCardData.petCards,
        .productivity: DummyCardData.productivityCards,
        .rest: DummyCardData.restCards
    ]
    
    init() {
        updateCards()
    }
    
    private func updateCards() {
        filteredCards = allCards[selectedCategory] ?? []
    }
}

@Observable
final class DetailViewModel {
    var selectedTasks: Set<String> = []
    
    func saveSelectedTasks() {
        // TODO: 저장 로직 구현
        print("선택된 작업 저장: \(selectedTasks)")
    }
}
