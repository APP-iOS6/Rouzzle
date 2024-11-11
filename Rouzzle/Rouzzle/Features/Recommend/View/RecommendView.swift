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
    @Namespace private var animationNamespace
    
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
            
            RecommendCategoryView(selectedCategory: $selectedCategory)
            
            // 임시로 RecommendCardView 추가
            RecommendCardView(
                card: Card(
                    title: "오타니 쇼헤이",
                    imageName: "⚾️",
                    fullText: "오타니 쇼헤이는 세계적인 야구 선수로, 그의 하루는 철저한 관리와 노력으로 이루어져 있습니다.",
                    routines: []
                ),
                animation: animationNamespace,
                onTap: {
                    print("탭탭!")
                }
            )
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

#Preview {
    RecommendView()
}
