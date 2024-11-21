//
//  RoutineSuccessRateChart2.swift
//  Rouzzle
//
//  Created by 김동경 on 11/19/24.
//

import SwiftUI
import Charts

struct RoutineSuccessRateChart: View {
    
    let percentage: Double
    let emoji: String
    let title: String
    @State private var animatedValue: Double = 0
    
    var body: some View {
        GeometryReader { _ in
            HStack(alignment: .center) {
                Text(emoji)
                    .font(.system(size: 20))
                    .padding(.trailing, 8)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.chart.opacity(0.1))
                        .frame(height: 26)
                    Chart {
                        BarMark(
                            x: .value("성공률", min(animatedValue, 100)),
                            y: .value("Label", "성공률")
                        )                        .foregroundStyle(getColor(for: animatedValue))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .frame(height: 32)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .chartXAxis(.hidden)
                    .chartYAxis(.hidden)
                    .chartXScale(domain: 0...100)
                    .chartPlotStyle { plotArea in
                        plotArea
                            .background(.clear)
                            .border(.clear, width: 0)
                    }
                }
                .overlay(alignment: .leading) {
                    Text(title)
                        .font(.medium12)
                        .offset(x: 12)
                }
                Text("\(Int(percentage))%")
                    .font(.regular12)
                    .frame(width: 25)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .onChange(of: percentage) {
                startAnimation(percentage: percentage)
            }
            .onAppear {
                startAnimation(percentage: percentage)
            }
        }
    }
    private func startAnimation(percentage: Double) {
        
        withAnimation(nil) {
            animatedValue = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeOut(duration: 0.8)) {
                animatedValue = percentage
            }
        }
    }
    
    private func getColor(for value: Double) -> Color {
        switch value {
        case 100:
            return Color.chart
        case 50...:
            return Color.chart.opacity(0.7)
        default:
            return Color.chart.opacity(0.4)
        }
    }
}

#Preview {
    RoutineSuccessRateChart(percentage: 25, emoji: "😀", title: "요시를 패기")
}
