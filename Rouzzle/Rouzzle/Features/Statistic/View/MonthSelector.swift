//
//  MonthSelector.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/16/24.
//

import SwiftUI

struct MonthSelector: View {
    let viewModel: StatisticViewModel
    @State private var isMoving = false
    
    var body: some View {
        HStack(spacing: 8) {
            Button {
                moveMonth(-1)
            } label: {
                Image(systemName: "chevron.left")
                    .font(.regular14)
                    .foregroundStyle(.gray)
            }
            .disabled(isMoving)
            
            Text("\(viewModel.calendarState.extraData()[1])년 \(viewModel.calendarState.extraData()[0])월")
                .font(.regular14)
            
            Button {
                moveMonth(1)
            } label: {
                Image(systemName: "chevron.right")
                    .font(.regular14)
                    .foregroundStyle(.gray)
            }
            .disabled(isMoving)
        }
    }
    
    private func moveMonth(_ direction: Int) {
        guard !isMoving else { return }
        
        isMoving = true
        
        Task {
            // 월 이동
            await viewModel.calendarState.moveMonth(direction: direction)
            // 데이터 다시 로드
            await viewModel.loadRoutineCompletions()
            
            // UI 업데이트를 위해 메인 스레드에서 실행
            await MainActor.run {
                isMoving = false
            }
        }
    }
}
