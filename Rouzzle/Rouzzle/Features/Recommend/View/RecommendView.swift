//
//  RecommendView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/11/24.
//

import SwiftUI
import SwiftData

struct RecommendView: View {
    @State private var viewModel = RecommendViewModel()

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("추천")
                    .font(.semibold18)
                    .foregroundStyle(.basic)
                    .padding(.leading)
                Spacer()
            }
            .padding(.top, 20)

            RecommendCategoryView(selectedCategory: $viewModel.selectedCategory)
            
            RecommendCardListView(cards: $viewModel.filteredCards)

            Spacer()
        }
    }
}

#Preview {
    RecommendView()
}
