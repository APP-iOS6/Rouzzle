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
        GeometryReader { proxy in
            HStack(alignment: .center) {
                HStack {
                    Text(emoji)
                        .font(.system(size: 16))
                    
                    Text(title)
                        .font(.regular14)
                        .lineLimit(1)
                        .frame(maxWidth: proxy.size.width * 0.16, alignment: .leading)
                        .padding(.leading, 3)
                        .overlay(
                            Text(title.count > 5 ? String(title.prefix(5)) + "..." : title)
                                .font(.regular16)
                                .lineLimit(1)
                                .opacity(0)
                        )
                }
                .padding(.trailing, 8)
                
                Chart {
                    BarMark(
                        x: .value("성공률", min(animatedValue, 100)),
                        y: .value("Label", "성공률")
                    )
                    .annotation(position: .trailing) {
                        Text("\(Int(percentage))%")
                            .font(.medium11)
                            .foregroundStyle(.gray.opacity(0.7))
                            .padding(.leading, -2)
                    }
                }
                .frame(height: 15)
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .chartXScale(domain: 0...100)
                .chartPlotStyle { plotArea in
                    plotArea
                        .background(.clear)
                        .border(.clear, width: 0)
                }
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
}
