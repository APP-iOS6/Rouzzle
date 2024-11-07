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
    private var playBackgroundColor = Color.fromRGB(r: 252, g: 255, b: 240)
    private var pauseBackgroundColor = Color.fromRGB(r: 230, g: 235, b: 212)
    private var pausePuzzleTimerColor = Color.fromRGB(r: 191, g: 207, b: 154)
    
    @State var isShowingTaskListSheet: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            // MARK: 그라데이션 배경
            LinearGradient(
                colors: viewModel.isRunning ? [.white, playBackgroundColor] : [.white, pauseBackgroundColor],
                startPoint: .top,
                endPoint: .bottom
            )
            .transition(.opacity)
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.bold30)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 20)
                
                Text("💊 유산균 먹기")
                    .font(.bold24)
                    .padding(.top, 40)
                
                // MARK: 퍼즐 모양 타이머
                ZStack {
                    Image(.puzzleTimer)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(viewModel.isRunning ? Color.themeColor : pausePuzzleTimerColor)
                    
                    VStack(spacing: 0) {
                        Text(viewModel.timeRemaining.toTimeString())
                            .font(.bold66)
                            .foregroundStyle(.white)
                        
                        Text("5분")
                            .font(.regular18)
                            .foregroundStyle(viewModel.isRunning ? .accent : .white)
                    }
                }
                .padding(.top, 35)
                
                // MARK: 버튼 3개(일시정지, 체크, 건너뛰기)
                HStack(spacing: 14) {
                    // 일시정지 버튼
                    Button {
                        viewModel.isRunning.toggle()
                    } label: {
                        Image(viewModel.isRunning ? .pauseIcon : .playIcon)
                            .frame(width: 64, height: 64)
                    }
                    
                    // 할일 완료 버튼
                    Button {
                        // 할일 완료 로직
                    } label: {
                        Image(.checkIcon)
                            .frame(width: 72, height: 72)
                    }
                    
                    // 건너뛰기 버튼
                    Button {
                        // 건너뛰기 로직
                    } label: {
                        Image(.skipIcon)
                            .frame(width: 64, height: 64)
                    }
                }
                .padding(.top, 30)
                
                Text("다음 할일")
                    .font(.semibold16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 60)
                
                TaskStatusPuzzle(taskStatus: .pending, emojiText: "🧼", title: "설거지 하기")
                    .padding(.top, 18)
                
                Button {
                    isShowingTaskListSheet.toggle()
                } label: {
                    Text("할일 전체 보기")
                        .underline()
                }
                .padding(.top, 35)
            }
            .padding(.horizontal)

        }
        .sheet(isPresented: $isShowingTaskListSheet) {
            TaskListSheet()
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
