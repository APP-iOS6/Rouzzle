//
//  RoutineStartView.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/5/24.
//

import SwiftUI

struct RoutineStartView: View {
    private var viewModel: RoutineStartViewModel = RoutineStartViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack(alignment: .top) {
            // MARK: 배경(그라데이션 + 흰색 RoundedRectangle)
            LinearGradient(
                colors: viewModel.isRunning ? [.white, .themeColor] : [.white, .subHeadlineFontColor],
                startPoint: .top,
                endPoint: .center
            )
            .transition(.opacity)
            .ignoresSafeArea(edges: .top)
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.white)
                .frame(height: UIScreen.main.bounds.height * 0.6)
                .offset(y: UIScreen.main.bounds.height * 0.5)
                .ignoresSafeArea(edges: .bottom)
            
            VStack(spacing: 0) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.semibold24)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 20)
                
                Text("💊 유산균 먹기")
                    .font(.bold24)
                    .padding(.top, 10)
                
                Text("5분")
                    .font(.regular14)
                    .foregroundStyle(Color.subHeadlineFontColor)
                    .padding(.top, 10)
                
                // MARK: 퍼즐 모양 타이머
                ZStack {
                    Image(.puzzleTimer)
                    
                    Text(viewModel.timeRemaining.toTimeString())
                        .font(.bold54)
                        .foregroundStyle(viewModel.isRunning ? .primary : Color.subHeadlineFontColor)
                }
                .padding(.top, 30)
                
                // MARK: 버튼 3개(일시정지, 체크, 건너뛰기)
                HStack(spacing: 0) {
                    // 일시정지 버튼
                    Button {
                        viewModel.isRunning.toggle()
                    } label: {
                        Image(systemName: viewModel.isRunning ? "pause.circle.fill" : "play.circle.fill")
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
                .padding(.top, 30)
            }
        }
        .animation(.smooth, value: viewModel.isRunning)
        .onAppear {
            viewModel.startTimer()
        }
    }
}

#Preview {
    RoutineStartView()
}
