//
//  StatisticContentView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/16/24.
//

import SwiftUI

struct StatisticContentView: View {
    @Binding var selectedCategory: String
    @Binding var isShowingGuide: Bool
    
    let routines: [RoutineItem]
    let viewModel: StatisticViewModel
    @State private var isShowingRoutineSettings = false
    
    var body: some View {
        if routines.isEmpty {
            VStack {
                Spacer(minLength: 250)
                
                VStack(spacing: 16) {
                    Image(systemName: "chart.bar.xaxis.ascending.badge.clock")
                        .font(.system(size: 60))
                        .foregroundStyle(.graymedium)
                    
                    VStack(spacing: 8) {
                        Text("등록된 루틴이 없습니다.")
                            .font(.medium16)
                            .foregroundStyle(.graymedium)
                    }
                }
                
                Spacer()
            }
        } else {
            StatisticCategoryView(
                selectedCategory: $selectedCategory,
                routines: routines
            )
            .padding(.top, 20)
            
            if selectedCategory == "요약" {
                SummaryView(viewModel: viewModel)
                    .padding(.horizontal)
                    .padding(.top, 20)
            } else {
                VStack(spacing: 20) {
                    CalendarView(
                        viewModel: viewModel.calendarViewModel,
                        isShowingGuide: $isShowingGuide
                    )
                }
            }
        }
    }
}
