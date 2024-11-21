//
//  SummaryView2.swift
//  Rouzzle
//
//  Created by 김동경 on 11/19/24.
//

import SwiftUI

struct SummaryView: View {
    
    @ObservedObject var store: StatisticStore
    let routines: [RoutineItem]
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 20) {
                if let (routineId, count) = store.findRoutineWithMaxStreak() {
                    Text("나의 최대 연속 기록이에요!")
                        .font(.medium16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    HStack(alignment: .center) {
                        Text("\(count)회")
                            .font(.semibold24)
                        if let routine = routines.first(where: { $0.id == routineId }) {
                            Text(routine.title)
                                .font(.regular14)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                } else {
                    Text("아직 연속 루틴 기록이 없습니다.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.medium16)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.backgroundLightGray)
            )
            
            HStack {
                
                Text("월간 성공률")
                    .font(.bold16)
                
                Spacer()
                
                MonthSelector(
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
                    
                    RoutineSuccessRateChart(
                        percentage: percentage,
                        emoji: routine.emoji,
                        title: routine.title
                    )
                    .padding(.vertical, 12)
                }
                Spacer()
                    .frame(height: 12)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    SummaryView(store: .init(), routines: [])
}
