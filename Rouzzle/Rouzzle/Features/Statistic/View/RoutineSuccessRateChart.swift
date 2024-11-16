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
    
    var body: some View {
        HStack(alignment: .center, spacing: -15) { // alignment 추가
            HStack(spacing: 2) {
                Text(routine.emoji)
                    .font(.system(size: 16))
                    .frame(width: 24)
                
                Text(routine.title)
                    .font(.regular16)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(width: 80, alignment: .leading)
            }
            .frame(width: 110, alignment: .leading)
            
            Chart {
                BarMark(
                    x: .value("Percentage", animatedValue),
                    y: .value("Label", "성공률"),
                    height: 10
                )
                .foregroundStyle(getBarColor(for: routine).gradient)
                .annotation(position: .trailing) {
                    Text("\(viewModel.calculateSuccessRate(for: routine))%")
                        .font(.medium11)
                        .foregroundStyle(.gray.opacity(0.7))
                        .padding(.leading, -2)
                }
            }
            .frame(height: 10)
            .frame(maxWidth: 220)
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .chartXScale(domain: 0...100)
            .chartPlotStyle { plotArea in
                plotArea
                    .background(.clear)
                    .border(.clear, width: 0)
            }
        }
        .padding(.vertical)
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
        let targetValue = Double(viewModel.calculateSuccessRate(for: routine))
        animatedValue = 0
        withAnimation(.easeOut(duration: 0.8)) {
            animatedValue = targetValue
        }
    }
}
