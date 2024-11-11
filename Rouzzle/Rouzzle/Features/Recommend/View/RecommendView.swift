//
//  RecommendView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/11/24.
//

import SwiftUI
import SwiftData

struct RecommendView: View {
    @State private var selectedCategory: String = "유명인"
    
    var body: some View {
        VStack {
            HStack {
                Text("추천")
                    .font(.semibold18)
                    .foregroundStyle(.basic)
                    .padding(.leading)
                Spacer()
            }
            .padding(.top, 20)
            
            Spacer()

            RecommendCategoryView(selectedCategory: $selectedCategory)
        }
    }
}

#Preview {
    RecommendView()
}
