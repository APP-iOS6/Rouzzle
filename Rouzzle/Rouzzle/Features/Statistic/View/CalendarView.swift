//
//  CalendarView2.swift
//  Rouzzle
//
//  Created by 김동경 on 11/18/24.
//

import SwiftUI

struct CalendarView: View {
    
    @ObservedObject var store: StatisticStore
    let routine: RoutineItem
    
    var body: some View {
        VStack(spacing: 35) {
            HStack {
                Text("월간 요약")
                    .font(.bold16)
                Image(systemName: "questionmark.circle")
                    .frame(width: 15, height: 15)
                    .foregroundStyle(Color.graymedium)
                    .onTapGesture {
                        withAnimation {
                            store.isShowingGuide.toggle()
                        }
                    }
                Spacer()
                
                MonthSelector(
                    title: store.currentDate.extraData,
                    isLoading: $store.isLoading
                ) { value in
                    store.moveMonth(direction: value)
                }
            }
            
            // 요일 헤더 표시
            HStack(spacing: 0) {
                ForEach(Array(store.koreanDays.enumerated()), id: \.element) { index, day in
                    Text(day)
                        .font(.medium12)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(store.getDayColor(for: index))
                }
            }
            
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(store.days) { value in
                    if value.day != -1 {
                        let completionStatus = store.getDayCompleteState(value.date, routineId: routine.id)
                        CalendarDayView(
                            completionStatus: completionStatus,
                            value: value
                        ) {
                            withAnimation {
                                store.puzzleTapped(value.date, routineId: routine.id)
                            }
                        }
                            .id(value.id)
                    } else {
                        Color.clear
                            .frame(height: 40)
                    }
                }
            }
            .animation(.none, value: store.days)
        }
    }
}

#Preview {
    CalendarView(store: .init(), routine: RoutineItem.sampleData[0])
}
