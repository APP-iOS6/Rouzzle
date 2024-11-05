//
//  RoutineStartView.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/5/24.
//

import SwiftUI

struct RoutineStartView: View {
    private var viewModel: RoutineStartViewModel = RoutineStartViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            // MARK: 배경(그라데이션 + 흰색 RoundedRectangle)
            LinearGradient(
                colors: viewModel.timerState == .running ? [.white, .themeColor] : [.white, .subHeadlineFontColor],
                startPoint: .top,
                endPoint: .center
            )
            .ignoresSafeArea(edges: .top)
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.white)
                .frame(height: UIScreen.main.bounds.height * 0.6)
                .offset(y: UIScreen.main.bounds.height * 0.5)
                .ignoresSafeArea(edges: .bottom)
            
            VStack(spacing: 0) {
                Text("💊 유산균 먹기")
                    .font(.bold24)
                
                Text("5분")
                    .font(.regular14)
                    .foregroundStyle(Color.subHeadlineFontColor)
                    .padding(.top, 19)
                
                // MARK: 퍼즐 모양 타이머
                ZStack {
                    Image(.puzzleTimer)
                    
                    Text(viewModel.timeString(from: viewModel.timeRemaining))
                        .font(.bold54)
                        .foregroundStyle(viewModel.timerState == .running ? .primary : Color.subHeadlineFontColor)
                        .onAppear {
                            viewModel.startTimer()
                        }
                }
                .padding(.top, 31)
                
                // MARK: 버튼 3개(일시정지, 체크, 건너뛰기)
                HStack(spacing: 0) {
                    // 일시정지 버튼
                    Button {
                        viewModel.toggleTimer()
                    } label: {
                        Image(systemName: viewModel.timerState == .running ? "pause.circle.fill" : "play.circle.fill")
                            .font(.bold50)
                            .foregroundStyle(Color.themeColor)
                            .background(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65)
                            )
                    }
                    
                    // 할일 완료 버튼
                    Button {
                        // 할일 완료 로직
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.bold80)
                            .foregroundStyle(Color.themeColor)
                            .background(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 100, height: 100)
                            )
                    }
                    
                    // 건너뛰기 버튼
                    Button {
                        // 건너뛰기 로직
                    } label: {
                        Image(systemName: "forward.end.circle.fill")
                            .font(.bold50)
                            .foregroundStyle(Color.themeColor)
                            .background(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65)
                            )
                    }
                }
                .padding(.top, 47)
            }
        }
        .padding(.horizontal, -16)
        .customNavigationBar(title: "")
    }
}

#Preview {
    NavigationStack {
        RoutineStartView()
    }
}
