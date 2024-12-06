//
//  EmojiPickerViewModel.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/8/24.
//

import SwiftUI

@Observable
class EmojiPickerViewModel {
    var searchText: String = ""
    var selectedCategory: EmojiCategory = .recent
    var isEmojiSelected: Bool = false
    var allEmojis: [EmojiCategory: [String]] = [:]
    var recentEmojis: [String] = []
    
    private let haptics = UIImpactFeedbackGenerator(style: .medium)
    
    init(recentEmojis: [String] = []) {
        self.recentEmojis = recentEmojis
        self.allEmojis = EmojiCategoryData.categoryEmojis
    }
    
    var filteredEmojis: [String] {
        if searchText.isEmpty {
            return selectedCategory == .recent ? recentEmojis : allEmojis[selectedCategory] ?? []
        } else {
            let lowercasedSearch = searchText.lowercased()
            let searchResults = EmojiSearchKeywords.emojiSearchData.filter { _, keywords in
                keywords.contains { $0.lowercased().contains(lowercasedSearch) }
            }.map { $0.key }
            
            if !searchResults.isEmpty {
                return searchResults
            }
            
            if let categoryWords = EmojiSearchKeywords.categoryKeywords[selectedCategory],
               categoryWords.contains(where: { $0.lowercased().contains(lowercasedSearch) }) {
                return allEmojis[selectedCategory] ?? []
            }
            
            return allEmojis.values.flatMap { $0 }.filter { emoji in
                emoji.lowercased().contains(lowercasedSearch)
            }
        }
    }
    
    func selectEmoji(_ emoji: String) {
        haptics.impactOccurred()
        isEmojiSelected = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isEmojiSelected = false
        }
        
        addToRecents(emoji)
    }
    
    func addToRecents(_ emoji: String) {
        if let index = recentEmojis.firstIndex(of: emoji) {
            recentEmojis.remove(at: index)
        }
        recentEmojis.insert(emoji, at: 0)
        
        if recentEmojis.count > 20 {
            recentEmojis.removeLast()
        }
    }
}
