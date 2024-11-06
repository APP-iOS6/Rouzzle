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
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                // MARK: 그라데이션 배경
                LinearGradient(
                    colors: viewModel.isRunning ? [.white, .themeColor] : [.white, .subHeadlineFontColor],
                    startPoint: .top,
                    endPoint: .center
                )
                .transition(.opacity)
                .ignoresSafeArea(edges: .top)
                
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
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 16)
                        
                        Text(viewModel.timeRemaining.toTimeString())
                            .font(.bold54)
                            .foregroundStyle(viewModel.isRunning ? .primary : Color.subHeadlineFontColor)
                    }
                    .padding(.top, 30)
                    
                    // MARK: 흰색 사각형 + 버튼 3개(일시정지, 체크, 건너뛰기) + 할일 리스트
                    ZStack(alignment: .top) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white)
                            .offset(y: geometry.size.height * 0.06)
                            .ignoresSafeArea(edges: .bottom)
                        
                        VStack(spacing: 0) {
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
                            
                            // 할일 리스트
                            ScrollView {
                                VStack(spacing: 10) {
                                    TaskStatusPuzzle(taskStatus: .inProgress)
                                    
                                    TaskStatusPuzzle(taskStatus: .pending)
                                        .shadow(color: .black.opacity(0.1), radius: 2)
                                    
                                    TaskStatusPuzzle(taskStatus: .completed)
                                }
                                .padding(.horizontal, 16)
                            }
                            .padding(.top, 7)
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
}

#Preview {
    RoutineStartView()
}
