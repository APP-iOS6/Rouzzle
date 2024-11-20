//
//  AddTaskView.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/6/24.
//

import SwiftUI
import SwiftData

struct AddTaskView: View {
    var store: RoutineStore
    @Environment(\.modelContext) private var modelContext
    @State var isShowingAddTaskSheet: Bool = false
    @State var isShowingTimerView: Bool = false
    @State var isShowingRoutineSettingsSheet: Bool = false
    @State var isShowingEditRoutineSheet: Bool = false
    @State private var toast: ToastModel?
    @State private var detents: Set<PresentationDetent> = [.fraction(0.12)]
        
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Label(store.todayStartTime, systemImage: "clock")
                        .font(.regular14)
                        .foregroundStyle(Color.subHeadlineFontColor)
                        .padding(.top, 15)
                    
                    Button {
                        isShowingTimerView.toggle()
                    } label: {
                        Image(.routineStart)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .padding(.top, -2)
                    
                    ForEach(store.taskList) { task in
                        TaskStatusPuzzle(task: task)
                            .padding(.vertical, 6)
                    }
                    
                    HStack {
                        Text("추천 할 일")
                            .font(.bold18)
                        
                        Spacer()
                        
                        Button {
                            store.getRecommendTask()
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.white)
                                .font(.caption)
                                .background(
                                    Circle()
                                        .fill(Color.subHeadlineFontColor)
                                )
                        }
                    }
                    .padding(.top, 30)
                    
                    // 추천 리스트
                    VStack(spacing: 10) {
                        ForEach(store.recommendTodoTask, id: \.self) { recommend in
                            TaskRecommendPuzzle(recommendTask: recommend) {
                                Task {
                                    await store.addTask(recommend, context: modelContext)
                                }
                            }
                        }
                    }
                    .animation(.smooth, value: store.recommendTodoTask)
                    
                    HStack(alignment: .bottom) {
                        Text("추천 세트")
                            .font(.bold18)
                        
                        Spacer()
                        
                        Text("테마별 추천 할 일을 모아놨어요!")
                            .font(.regular12)
                            .foregroundStyle(Color.subHeadlineFontColor)
                    }
                    .padding(.top, 10)
                    
                    HStack(spacing: 14) {
                        ForEach(RoutineCategoryByTime.allCases, id: \.self) { category in
                            NavigationLink {
                                TimeBasedRecommendSetView(category: category) { tasks in
                                    Task {
                                        await store.addTasks(tasks, context: modelContext)
                                    }
                                }
                            } label: {
                                Text(category.rawValue)
                                    .font(.semibold16)
                                    .foregroundStyle(.black)
                                    .frame(width: 82, height: 67)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.fromRGB(r: 239, g: 239, b: 239), lineWidth: 1)
                                    )
                            }

                        }
                    }
                    .padding(.top, 10)
                }
                .padding(.bottom, 50)
                .customNavigationBar(title: "\(store.routineItem.emoji) \(store.routineItem.title)")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isShowingRoutineSettingsSheet.toggle()
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.semibold20)
                        }
                    }
                }
                .fullScreenCover(isPresented: $isShowingTimerView) {
                    RoutineStartView(
                        viewModel: RoutineStartViewModel(
                            routineItem: store.routineItem
                        )
                    )
                }
                .fullScreenCover(isPresented: $isShowingEditRoutineSheet) {
                    EditRoutineView(viewModel: EditRoutineViewModel(routine: store.routineItem)) { _ in
                        store.loadState = .completed
                        store.toastMessage = "수정에 성공했습니다."
                    }
                 }
                .sheet(isPresented: $isShowingAddTaskSheet) {
                    NewTaskSheet(detents: $detents) { task in
                        Task {
                           await store.addTask(task, context: modelContext)
                        }
                    }
                    .presentationDetents(detents)
                }
                .sheet(isPresented: $isShowingRoutineSettingsSheet) {
                    RoutineSettingsSheet(isShowingEditRoutineSheet: $isShowingEditRoutineSheet)
                        .presentationDetents([.fraction(0.25)])
                }
            }
            
            FloatingButton {
                isShowingAddTaskSheet.toggle()
            }
            .padding()
        }
        .toastView(toast: $toast) // ToastModifier 적용
        .overlay {
            if store.loadState == .loading {
                ProgressView()
            }
        }
        .onChange(of: store.toastMessage, { _, new in
            guard let new else {
                return
            }
            if store.loadState == .completed {
                toast = ToastModel(type: .success, message: new)
                store.toastMessage = nil
            } else {
                toast = ToastModel(type: .warning, message: new)
                store.toastMessage = nil
            }
        })
        .animation(.smooth, value: store.taskList)
    }
    // Task를 추가
    private func addTaskToRoutine(_ task: RecommendTodoTask) {
        do {
            try SwiftDataService.addTask(to: store.routineItem, TaskList(title: task.title, emoji: task.emoji, timer: Int(exactly: task.timer)!), context: modelContext)
        } catch {
            print("할일 추가 실패")
        }
    }
}

#Preview {
    NavigationStack {
        AddTaskView(store: RoutineStore(routineItem: RoutineItem.sampleData[0]))
            .modelContainer(SampleData.shared.modelContainer)
    }
}
