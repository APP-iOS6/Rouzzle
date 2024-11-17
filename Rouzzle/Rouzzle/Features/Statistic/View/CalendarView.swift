//
//  CalendarView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/13/24.
//

import SwiftUI

struct CalendarView: View {
    @Bindable var viewModel: CalendarViewModel
    @Binding var isShowingGuide: Bool
    var body: some View {
        VStack(spacing: 35) {
            // 년월 표시 및 이동 버튼
            HStack {
                Text("월간 요약")
                    .font(.bold16)
                Image(systemName: "questionmark.circle")
                    .frame(width: 15, height: 15)
                    .foregroundStyle(Color.graymedium)
                    .onTapGesture {
                        isShowingGuide.toggle()
                    }
                Spacer()
                
                HStack(spacing: 8) {
                    Button {
                        viewModel.moveMonth(direction: -1)
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.regular14)
                            .foregroundStyle(Color.gray)
                    }
                    
                    Text(viewModel.extraData()[1] + "년 " + viewModel.extraData()[0] + "월")
                        .font(.regular14)
                    
                    Button {
                        viewModel.moveMonth(direction: 1)
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.regular14)
                            .foregroundStyle(Color.gray)
                    }
                }
            }
            
            // 요일 헤더 표시
            HStack(spacing: 0) {
                ForEach(Array(viewModel.koreanDays.enumerated()), id: \.element) { index, day in
                    Text(day)
                        .font(.medium12)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(viewModel.getDayColor(for: index))
                }
            }
            
            // 날짜 그리드 표시
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(viewModel.days) { value in
                    VStack {
                        if value.day != -1 {
                            ZStack {
                                if let status = viewModel.getTaskStatus(for: value.date) {
                                    if status == .fullyComplete {
                                        Image(systemName: "puzzlepiece.extension.fill")
                                            .font(.system(size: 35))
                                            .foregroundStyle(Color.accentColor)
                                        Text("\(value.day)")
                                            .font(.medium16)
                                            .foregroundStyle(Color.white)
                                            .frame(width: 35, height: 35)
                                    } else {
                                        Image(systemName: "puzzlepiece.extension.fill")
                                            .font(.system(size: 35))
                                            .foregroundStyle(Color.partiallyCompletePuzzle)
                                        Text("\(value.day)")
                                            .font(.medium16)
                                            .foregroundStyle(Color.primary)
                                            .frame(width: 35, height: 35)
                                    }
                                } else {
                                    Text("\(value.day)")
                                        .font(.medium16)
                                        .foregroundStyle(Color.primary)
                                        .frame(width: 35, height: 35)
                                        .background(
                                            Circle()
                                                .fill(viewModel.isSameDay(date1: value.date, date2: Date()) ? Color.gray.opacity(0.3) : Color.clear)
                                        )
                                }
                            }
                            .frame(height: 40)
                        }
                    }
                }
            }
            
            // 테스트용 더미 데이터 버튼
            Button("더미 데이터 로드") {
                viewModel.loadDummyData()
            }
            .padding()
            .background(Color.themeColor)
            .cornerRadius(10)
        }
        .onAppear {
            viewModel.loadRoutineCompletions()
        }
        .onChange(of: viewModel.currentMonth) {
            viewModel.extractDate()
            viewModel.loadRoutineCompletions()
        }
    }
}
