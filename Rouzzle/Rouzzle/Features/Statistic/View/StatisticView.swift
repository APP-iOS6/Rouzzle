//
//  StatsView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import SwiftUI

struct StatisticView: View {
    @State var viewModel = StatisticViewModel()
    @State private var selectedCategory: String = "요약"
    @State private var isShowingGuide = false
    let routines = RoutineItem.sampleData
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Text("통계")
                            .font(.semibold18)
                        
                        Spacer()
                        
                        PieceCounter(count: 9)
                    }
                    .padding(.horizontal)
                    .padding(.top, 15)
                    
                    StatisticContentView(
                        selectedCategory: $selectedCategory,
                        isShowingGuide: $isShowingGuide,
                        routines: routines,
                        viewModel: viewModel
                    )
                }
                .padding(.bottom, 200)
            }
            .scrollIndicators(.hidden)
        }
        .ignoresSafeArea()
        .overlay {
            if isShowingGuide {
                StatisticGuideOverlay(isShowingGuide: $isShowingGuide)
            }
        }
    }
}

#Preview {
    StatisticView()
}
