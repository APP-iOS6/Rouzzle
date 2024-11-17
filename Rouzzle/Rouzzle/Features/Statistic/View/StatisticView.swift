//
//  StatsView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import SwiftUI
import SwiftData
import Charts

struct StatisticView: View {
    @Environment(\.modelContext) private var context
    @Query private var routinesQuery: [RoutineItem]
    @State private var selectedCategory: String = "요약"
    @State private var isShowingGuide: Bool = false
    
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
                        routines: routinesQuery,
                        viewModel: StatisticViewModel(
                            routines: routinesQuery,
                            context: context
                        )
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
