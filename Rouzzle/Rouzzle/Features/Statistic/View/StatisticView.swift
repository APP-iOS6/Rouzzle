//
//  StatsView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import SwiftUI

struct StatisticView: View {
    @State var viewModel = StatisticViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 캘린더 뷰
                    CalendarView(viewModel: viewModel.calendarViewModel)
                        .padding(.horizontal)
                    
                    // 월별 통계(테스트요)
                    VStack(spacing: 10) {
                        Text("월간 통계")
                            .font(.bold18)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        HStack(spacing: 15) {
                            StatBox(
                                title: "완료한 루틴",
                                count: viewModel.getCompletedCount(),
                                symbolName: "checkmark.circle.fill",
                                color: .accentColor
                            )
                            StatBox(
                                title: "부분 완료 루틴",
                                count: viewModel.getPartialCount(),
                                symbolName: "ellipsis.circle.fill",
                                color: .blue
                            )
                        }
                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("통계")
                        .font(.semibold18)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    PieceCounter(count: 9)
                }
            }
        }
    }
}

struct StatBox: View {
   let title: String
   let count: Int
   let symbolName: String
   let color: Color
   
   var body: some View {
       VStack(alignment: .leading, spacing: 8) {
           HStack {
               Image(systemName: symbolName)
                   .foregroundStyle(color)
               Text(title)
           }
           .font(.regular14)
           .foregroundStyle(.gray)
           
           Text("\(count)")
               .font(.bold24)
               .foregroundStyle(color)
       }
       .frame(maxWidth: .infinity, alignment: .leading)
       .padding()
       .background(Color.gray.opacity(0.1))
       .cornerRadius(12)
   }
}

#Preview {
   StatisticView()
}
