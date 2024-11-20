//
//  StatisticView2.swift
//  Rouzzle
//
//  Created by 김동경 on 11/18/24.
//

import SwiftUI
import SwiftData

struct StatisticView: View {
    
    @Query private var routinesQuery: [RoutineItem]
    @StateObject private var store: StatisticStore = StatisticStore()
    
    var body: some View {
        GeometryReader { proxy in
            NavigationStack {
                ScrollView {
                    VStack(spacing: 20) {
                        HStack {
                            Text("통계")
                                .font(.semibold18)
                            
                            Spacer()
                            
                            PieceCounter(count: 9)
                        }
                        .padding(.top, 2)
                        .padding(.trailing, 2)
                        
                        if routinesQuery.isEmpty {
                            // 루틴이 없을 때 보여주는 화면
                            EmptyStatisticView(proxy: proxy)
                        } else {
                            // 통계 카테고리 화면
                            StatisticDetailView(
                                store: store,
                                routines: routinesQuery,
                                proxy: proxy
                            )
                        }
                    }
                    .animation(.easeInOut, value: routinesQuery)
                    .padding()
                }
            }
            .overlay {
                if store.isShowingGuide {
                    StatisticGuideOverlay(isShowingGuide: $store.isShowingGuide)
                }
            }
            .overlay {
                if let completion = store.selectedTask {
                    RoutineCompletionOverlay(routineCompletion: completion) {
                        withAnimation {
                            store.selectedTask = nil
                        }
                    }
                }
            }
        }
    }
}

struct EmptyStatisticView: View {
    
    let proxy: GeometryProxy
    
    var body: some View {
        VStack {
            Spacer()
                .frame(minHeight: proxy.size.height * 0.3)
            
            Image(systemName: "chart.bar.xaxis.ascending.badge.clock")
                .font(.system(size: 60))
                .foregroundStyle(.graymedium)
            
            Text("등록된 루틴이 없습니다.")
                .font(.medium16)
                .foregroundStyle(.graymedium)
        }
    }
}

struct StatisticDetailView: View {
    
    @ObservedObject var store: StatisticStore
    @State private var selectedCategory: String = "요약"
    var routines: [RoutineItem]
    let proxy: GeometryProxy
    
    var body: some View {
        VStack {
            StatisticCategoryView(
                selectedCategory: $selectedCategory,
                routines: routines
            )
            .padding(.vertical, 20)
            .padding(.trailing, -16)
            
            if selectedCategory == "요약" {
                SummaryView(store: store, routines: routines)
            } else if let selectedRoutine = routines.first(where: { "\($0.emoji) \($0.title)" == selectedCategory }) {
                
                let routineStatistic = store.getRoutineStatistic(routineId: selectedRoutine.id)
                RoutineStatisticView(routineStatistic: routineStatistic, proxy: proxy)
                    .padding(.bottom, 24)

                CalendarView(
                    store: store,
                    routine: selectedRoutine
                )
                    .padding(.bottom, 24)
                
                Text("월간 성공률")
                    .font(.bold16)
                    .padding(.bottom, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack {
                    ForEach(selectedRoutine.taskList, id: \.id) { task in
                        let targetDay: Set<Int> = Set(selectedRoutine.dayStartTime.keys)
                        let percentage: Double = Double(store.summaryData[selectedRoutine.id]?.filter { $0.taskCompletions.contains { completion in
                            completion.isComplete && completion.title == task.title
                        }}.count ?? 0) / Double(store.countMTTDays(targetDay)) * 100
                        
                        RoutineSuccessRateChart(
                            percentage: percentage,
                            emoji: task.emoji,
                            title: task.title
                        )
                        .padding(.vertical, 12)
                    }
                    Spacer()
                        .frame(height: 12)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.backgroundLightGray)
                )
                
            } else {
                Text("선택된 루틴이 없습니다.")
                    .foregroundColor(.gray)
            }
        }
        .animation(.easeInOut, value: store.days)
        .animation(.easeInOut, value: selectedCategory)
    }
}

#Preview {
    StatisticView()
}
