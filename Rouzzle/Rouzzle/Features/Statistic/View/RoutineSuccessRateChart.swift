//
//  RoutineSuccessRateChart.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/16/24.
//

import SwiftUI
import Charts

struct RoutineSuccessRateChart: View {
    let routine: RoutineItem
    let viewModel: StatisticViewModel
    @State private var animatedValue: Double = 0
    private let maxWidth: Double = 220
    
    var body: some View {
        HStack(alignment: .center, spacing: -15) {
            HStack(spacing: 2) {
                Text(routine.emoji)
                    .font(.system(size: 16))
                    .frame(width: 24)
                
                Text(routine.title)
                    .font(.regular16)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(width: 60, alignment: .leading)
                    .overlay(
                        Text(routine.title.count > 5 ? routine.title.prefix(5) + "..." : routine.title)
                            .font(.regular16)
                            .lineLimit(1)
                            .opacity(0)
                    )
            }
            .frame(width: 110, alignment: .leading)
            
            let percentage = Double(viewModel.calculateSuccessRate(for: routine))
            
            Chart {
                BarMark(
                    x: .value("성공률", min(animatedValue, 100)),  // 최대값을 100으로 제한
                    y: .value("Label", "성공률"),
                    width: .fixed(maxWidth)
                )
                .foregroundStyle(getBarColor(for: routine).gradient)
                .annotation(position: .trailing) {
                    Text("\(Int(percentage))%")
                        .font(.medium11)
                        .foregroundStyle(.gray.opacity(0.7))
                        .padding(.leading, -2)
                }
            }
            .frame(width: maxWidth)
            .frame(height: 14)
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .chartXScale(domain: 0...100)  // 도메인을 0-100으로 고정
            .chartPlotStyle { plotArea in
                plotArea
                    .background(.clear)
                    .border(.clear, width: 0)
            }
        }
        .padding(.vertical, 10)
        .onAppear {
            animateGraph()
        }
        .onChange(of: viewModel.calendarViewModel.currentMonth) {
            animateGraph()
        }
    }
    
    private func getBarColor(for routine: RoutineItem) -> Color {
        if let index = viewModel.routines.firstIndex(where: { $0.id == routine.id }) {
            return index % 2 == 0 ? Color.accentColor : Color.themeColor
        }
        return Color.accent
    }
    
    private func animateGraph() {
        let percentage = Double(viewModel.calculateSuccessRate(for: routine))
        animatedValue = 0
        withAnimation(.easeOut(duration: 0.8)) {
            animatedValue = percentage
        }
    }
}
