//
//  StatisticCategoryView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/13/24.
//

import SwiftUI

struct StatisticCategoryView: View {
    @Binding var selectedCategory: String
    @State private var viewModel: StatisticViewModel
    
    init(selectedCategory: Binding<String>, viewModel: StatisticViewModel) {
        self._selectedCategory = selectedCategory
        self._viewModel = State(initialValue: viewModel)
    }
    
    var allCategories: [String] {
        let defaultCategories = ["요약"]
        let routineTitles = viewModel.routines.map { "\($0.emoji) \($0.title)" }
        return defaultCategories + routineTitles
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(allCategories, id: \.self) { category in
                    let isSelected = (category == selectedCategory)
                    Text(category)
                        .font(.semibold16)
                        .foregroundStyle(isSelected ? .accent : .graymedium)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(isSelected ? Color.opacitygreen : Color.white)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(isSelected ? Color.accent : .graymedium, lineWidth: 1)
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
