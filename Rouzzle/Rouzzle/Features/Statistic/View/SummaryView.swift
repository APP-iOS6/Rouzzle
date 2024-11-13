//
//  SummaryView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/13/24.
//

import SwiftUI

struct SummaryView: View {
    @State private var viewModel = StatisticViewModel()
    // 임시 데이터 구조
    struct RoutineData: Identifiable {
        let id = UUID()
        let emoji: String
        let title: String
        let progress: Double
    }
    
    // 샘플 데이터 (임시 데이터로만 사용)
    private let routines = [
        RoutineData(emoji: "☀️", title: "아침 루틴", progress: 0.8),
        RoutineData(emoji: "🌙", title: "저녁 루틴", progress: 0.5),
        RoutineData(emoji: "🏃‍♀️", title: "운동 루틴", progress: 0.62)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 최대 연속기록 박스
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("나의 최대 연속 기록이에요!")
                        .font(.medium16)
                    HStack(alignment: .bottom, spacing: 4) {
                        Text("0일")
                            .font(.bold36)
                        Text("아침 루틴")
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
                        .fill(Color.gray.opacity(0.1))
                )
            }
            .padding(.bottom, 20)
            
            HStack {
                Text("월간 성공률")
                    .font(.bold16)
                
                Spacer()
                
                HStack(spacing: 8) {
                    Button {
                        viewModel.calendarViewModel.moveMonth(direction: -1)
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.regular14)
                            .foregroundStyle(.gray)
                    }
                    
                    Text("\(viewModel.calendarViewModel.extraData()[1])년 \(viewModel.calendarViewModel.extraData()[0])월")
                        .font(.regular14)
                    
                    Button {
                        viewModel.calendarViewModel.moveMonth(direction: 1)
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.regular14)
                            .foregroundStyle(.gray)
                    }
                }
            }
            // 루틴별 성공률 한 박스
            VStack(spacing: 20) {
                ForEach(Array(routines.enumerated()), id: \.1.id) { index, routine in
                    HStack(spacing: 4) {
                        // 이모지
                        Text(routine.emoji)
                            .font(.system(size: 16))
                            .frame(width: 20)
                        
                        // 루틴 이름
                        Text(routine.title)
                            .font(.regular16)
                            .frame(width: 70, alignment: .leading)
                        
                        // 프로그레스바와 퍼센트를 묶어서 처리
                        ZStack(alignment: .leading) {
                            GeometryReader { geometry in
                                ZStack(alignment: .trailing) {
                                    Rectangle()
                                        .fill(index % 2 == 0 ? Color.accentColor : Color.themeColor)
                                        .frame(width: geometry.size.width * routine.progress, height: 10)
                                    
                                    Text("\(Int(routine.progress * 100))%")
                                        .font(.medium11)
                                        .foregroundStyle(.gray.opacity(0.7))
                                        .offset(x: 26)
                                }
                            }
                            .frame(height: 10)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .frame(height: 145)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
            )
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SummaryView()
}
