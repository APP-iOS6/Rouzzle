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
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    Text(category.rawValue)
                        .font(.semibold16)
                        .foregroundStyle(
                            selectedCategory == category ? .white : .graymedium
                        )
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(
                                    selectedCategory == category ? Color.accentColor : Color.white
                                )
                        )
                        .onTapGesture {
                            selectedCategory = category
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    RecommendCategoryView(selectedCategory: .constant(.celebrity))
}
