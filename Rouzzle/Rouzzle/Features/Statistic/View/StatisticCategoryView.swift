//
//  StatisticCategoryView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/13/24.
//

import SwiftUI

struct StatisticCategoryView: View {
    @Binding var selectedCategory: String
    let routines = RoutineItem.sampleData
    
    var allCategories: [String] {
        let defaultCategories = ["요약"]
        let routineTitles = routines.map { "\($0.emoji) \($0.title)" }
        return defaultCategories + routineTitles
    }
    
    var body: some View {
        // 카테고리 목록
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(allCategories, id: \.self) { category in
                    let isSelected = (category == selectedCategory)
                    Text(category)
                        .font(.semibold16)
                        .foregroundStyle(isSelected ? .white : .accentColor)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(isSelected ? Color.accentColor : Color.white)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.accent, lineWidth: 1)
                        )
                        .onTapGesture {
                            selectedCategory = category
                        }
                }
            }
            .padding(.horizontal)
            .padding(.leading, 1)
            .padding(.vertical, 1)
        }
    }
}
