//
//  SummaryView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/13/24.
//

import SwiftUI
import Charts

struct SummaryView: View {
    let viewModel: StatisticViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 최대 연속기록 박스
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("나의 최대 연속 기록이에요!")
                        .font(.medium16)
                    HStack(alignment: .bottom, spacing: 8) {
                        Text("\(viewModel.getMaxConsecutiveDays())일")
                            .font(.bold36)
                        Text(viewModel.getMaxConsecutiveRoutineName())
                            .font(.regular16)
                            .foregroundStyle(.gray)
                            .alignmentGuide(.bottom) { $0[.bottom] + 4 }
                        Spacer()
                    }
                }
                .padding()
                .frame(height: 107)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.backgroundLightGray)
                )
            }
            .padding(.bottom, 20)
            
            HStack {
                Text("월간 성공률")
                    .font(.bold16)
                
                Spacer()
                
                MonthSelector(viewModel: viewModel)
            }
            
            // 루틴별 성공률 차트
            VStack(spacing: 8) {
                ForEach(viewModel.routines) { routine in
                    RoutineSuccessRateChart(routine: routine, viewModel: viewModel)
                }
            }
            .padding(.vertical, 12)
            .padding(.leading, -25)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.backgroundLightGray)
            )
        }
        .frame(maxWidth: .infinity)
    }
}
