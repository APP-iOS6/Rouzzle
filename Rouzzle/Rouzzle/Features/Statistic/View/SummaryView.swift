//
//  SummaryView2.swift
//  Rouzzle
//
//  Created by 김동경 on 11/19/24.
//

import SwiftUI

struct SummaryView2: View {
    
    @ObservedObject var store: StatisticStore
    let routines: [RoutineItem]
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                
                Text("월간 성공률")
                    .font(.bold16)
                
                Spacer()
                
                MonthSelector2(
                    title: store.currentDate.extraData,
                    isLoading: $store.isLoading
                ) { value in
                    store.moveMonth(direction: value)
                }
            }
            VStack {
                ForEach(routines, id: \.id) { routine in
                    let targetDay: Set<Int> = Set(routine.dayStartTime.keys)
                    let percentage: Double = Double(store.summaryData[routine.id]?.filter { $0.isCompleted }.count ?? 0) / Double(store.countMTTDays(targetDay)) * 100
                    
                    RoutineSuccessRateChart2(
                        percentage: percentage,
                        emoji: routine.emoji,
                        title: routine.title
                    )
                    .padding(.vertical, 12)
                }
                Spacer()
                    .frame(height: 12)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.backgroundLightGray)
            )
        }
    }
}

#Preview {
    SummaryView2(store: .init(), routines: [])
}
