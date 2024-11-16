//
//  MonthSelector.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/16/24.
//

import SwiftUI

struct MonthSelector: View {
    let viewModel: StatisticViewModel
    
    var body: some View {
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
}
