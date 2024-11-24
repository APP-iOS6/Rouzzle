//
//  RecommendCategoryView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/11/24.
//

import SwiftUI

struct RecommendCategoryView: View {
    @Binding var selectedCategory: RecommendViewModel.Category
    let categories = RecommendViewModel.Category.allCases
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(categories, id: \.self) { category in
                    let isSelected = (category == selectedCategory)
                    Text(category.rawValue)
                        .font(.semibold16)
                        .foregroundStyle(isSelected ? .accent : .graymedium)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(isSelected ? Color.opacityGreen : Color.white)
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

#Preview {
    RecommendCategoryView(selectedCategory: .constant(.celebrity))
}
