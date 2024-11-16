//
//  SummaryView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/13/24.
//

import SwiftUI

struct SummaryView: View {
    let viewModel: StatisticViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 최대 연속기록 박스
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("나의 최대 연속 기록이에요!")
                        .font(.medium16)
                    HStack(alignment: .bottom, spacing: 8) {
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
                        .fill(Color.backgroundLightGray)
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
            
            // 루틴별 성공률 표시
            VStack(spacing: 20) {
                ForEach(viewModel.routines) { routine in
                    RoutineSuccessRateRow(routine: routine, viewModel: viewModel)
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.backgroundLightGray)
            )
        }
        .frame(maxWidth: .infinity)
    }
}

// 루틴별 성공률을 보여주는 새로운 컴포넌트
struct RoutineSuccessRateRow: View {
    let routine: RoutineItem
    let viewModel: StatisticViewModel
    
    var body: some View {
        HStack(spacing: 4) {
            Text(routine.emoji)
                .font(.system(size: 16))
                .frame(width: 20)
            
            Text(routine.title)
                .font(.regular16)
                .frame(width: 70, alignment: .leading)
            
            // 프로그레스바와 퍼센트 표시
            ZStack(alignment: .leading) {
                GeometryReader { geometry in
                    ZStack(alignment: .trailing) {
                        Rectangle()
                            .fill(Color.accentColor)
                            .frame(width: geometry.size.width * 0.8, height: 10) // 성공률에 따라 조정 필요
                        
                        Text("80%")  // 성공률에 따라 조정 필요
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
