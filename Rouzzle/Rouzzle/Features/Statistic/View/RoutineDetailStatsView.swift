//
//  RoutineDetailStatsView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/17/24.
//

import SwiftUI

struct RoutineDetailStatsView: View {
    let routine: RoutineItem
    let viewModel: StatisticViewModel
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.backgroundLightGray)
            .frame(maxWidth: .infinity)
            .frame(height: 107)
            .overlay(
                HStack(spacing: 15) {
                    // 현재 연속일
                    VStack(spacing: 8) {
                        Text("\(viewModel.getCurrentStreak(for: routine))")
                            .font(.bold24)
                        Text("현재 연속일")
                            .font(.regular12)
                            .foregroundStyle(Color.subHeadlineFontColor)
                    }
                    .frame(maxWidth: .infinity)
                    
                    DashedDivider()
                    
                    // 최대 연속일
                    VStack(spacing: 8) {
                        Text("\(viewModel.getMaxStreak(for: routine))")
                            .font(.bold24)
                        Text("최대 연속일")
                            .font(.regular12)
                            .foregroundStyle(Color.subHeadlineFontColor)
                    }
                    .frame(maxWidth: .infinity)
                    
                    DashedDivider()
                    
                    // 누적일
                    VStack(spacing: 8) {
                        Text("\(viewModel.getTotalCompletedDays(for: routine))")
                            .font(.bold24)
                        Text("누적일")
                            .font(.regular12)
                            .foregroundStyle(Color.subHeadlineFontColor)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
            )
    }
}

struct DashedDivider: View {
    var body: some View {
        VStack(spacing: 4) {
            ForEach(0..<8, id: \.self) { _ in
                Rectangle()
                    .fill(Color.subHeadlineFontColor.opacity(0.3))
                    .frame(width: 1, height: 3)
            }
        }
    }
}
