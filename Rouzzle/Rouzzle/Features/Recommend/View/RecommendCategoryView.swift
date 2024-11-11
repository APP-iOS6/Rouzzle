//
//  RecommendCategoryView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/11/24.
//

import SwiftUI

struct RecommendCategoryView: View {
    @Binding var selectedCategory: String
    
    let categories = [
        "유명인", "아침", "저녁", "건강", "반려동물", "생산성", "휴식"
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    Text(category)
                        .font(.semibold16)
                        .foregroundStyle(
                            selectedCategory == category ? .white : .deactivation
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
    RecommendCategoryView(selectedCategory: .constant("유명인"))
}
