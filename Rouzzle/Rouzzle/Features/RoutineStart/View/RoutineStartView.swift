//
//  RoutineStartView.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/5/24.
//

import SwiftUI

struct RoutineStartView: View {
    @State var viewModel: RoutineStartViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State var isShowingTaskListSheet: Bool = false
    @State private var detents: Set<PresentationDetent> = [.fraction(0.5)]
    @Binding var path: NavigationPath
    var body: some View {
        ZStack(alignment: .top) {
            // MARK: 그라데이션 배경
            LinearGradient(
                colors: viewModel.timerState.gradientColors,
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
                .padding(.top, 10)
                
                if let inProgressTask = viewModel.inProgressTask {
                    Text("\(inProgressTask.emoji) \(inProgressTask.title)")
                        .font(.bold24)
                        .padding(.top, 40)
                }
                
                // MARK: 퍼즐 모양 타이머
                ZStack {
                    Image(.puzzleTimer)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(viewModel.timerState.puzzleTimerColor)
                    
                    VStack(spacing: 0) {
                        if (viewModel.inProgressTask?.timer) != nil {
                            if viewModel.timeRemaining >= 0 {
                                Text(viewModel.timeRemaining.toTimeString())
                                    .font(.bold66)
                                    .foregroundStyle(.white)
                            } else {
                                Text("+\(abs(viewModel.timeRemaining).toTimeString())")
                                    .font(.bold66)
                                    .foregroundStyle(viewModel.timerState == .paused ? .white : Color(.overtimeText))
                            }
                        } else {
                            Text("Check!")
                                .font(.bold66)
                                .foregroundStyle(.white)
                        }
                        
                        if let timerValue = viewModel.inProgressTask?.timer {
                            Text(viewModel.timeRemaining >= 60 ? "\(timerValue / 60)분" : "\(timerValue)초")
                                .font(.regular18)
                                .foregroundStyle(viewModel.timerState.timeTextColor)
                        } else {
                            Text("")
                        }
                    }
                }
                .padding(.top, 35)
                
                // MARK: 버튼 3개(일시정지, 체크, 건너뛰기)
                HStack(spacing: 14) {
                    // 일시정지 버튼
                    Button {
                        viewModel.toggleTimer()
                    } label: {
                        Image(viewModel.timerState == .paused ? .playIcon : .pauseIcon)
                            .frame(width: 64, height: 64)
                    }
                    .disabled(viewModel.inProgressTask?.timer == nil)
                    
                    // 할일 완료 버튼
                    Button {
                        viewModel.markTaskAsCompleted()
                        //viewModel.toggleTimer()
                    } label: {
                        Image(.checkIcon)
                            .frame(width: 72, height: 72)
                    }
                    
                    // 건너뛰기 버튼
                    Button {
                        viewModel.skipTask()
                        viewModel.toggleTimer()
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
                
                if let nextTask = viewModel.nextPendingTask {
                    TaskStatusRow(
                        taskStatus: .pending,
                        emojiText: nextTask.emoji,
                        title: nextTask.title,
                        timeInterval: nextTask.timer,
                        showEditIcon: .constant(false),
                        showDeleteIcon: .constant(false)
                    )
                    .padding(.top, 18)
                }
                
                Spacer()
                
                Button {
                    isShowingTaskListSheet.toggle()
                } label: {
                    Text("할일 전체 보기")
                        .underline()
                }
                .padding(.bottom, 60)
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $isShowingTaskListSheet) {
            TaskListSheet(
                tasks: $viewModel.viewTasks,
                detents: $detents,
                inProgressTask: viewModel.inProgressTask
            )
            .presentationDetents(detents)
        }
        .fullScreenCover(isPresented: $viewModel.isRoutineCompleted) {
            RoutineCompleteView(path: $path, routineItem: viewModel.routineItem)
        }
        .animation(.smooth, value: viewModel.timerState)
        .onAppear {
            viewModel.resetTask()
            viewModel.startTimer()
        }
        .onDisappear {
            Task {
                await viewModel.saveRoutineCompletion()
            }
        }
    }
}

#Preview {
    let taskManager = CalendarTaskManager() // taskManager 생성
    RoutineStartView(
        viewModel: RoutineStartViewModel(
            routineItem: RoutineItem.sampleData[0]
        ), path: .constant(NavigationPath())
    )
    .modelContainer(SampleData.shared.modelContainer)
}
