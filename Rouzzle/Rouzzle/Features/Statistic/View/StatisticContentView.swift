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
    
    var body: some View {
        if routines.isEmpty {
            Text("등록된 루틴이 없습니다")
                .font(.medium16)
                .foregroundColor(.gray)
                .padding(.horizontal)
        } else {
            StatisticCategoryView(selectedCategory: $selectedCategory)
                .padding(.top, 20)
            
            if selectedCategory == "요약" {
                SummaryView()
                    .padding(.horizontal)
                    .padding(.top, 20)
            } else {
                VStack(spacing: 20) {
                    CalendarView(viewModel: viewModel.calendarViewModel, isShowingGuide: $isShowingGuide)
                }
            }
        }
    }
}
