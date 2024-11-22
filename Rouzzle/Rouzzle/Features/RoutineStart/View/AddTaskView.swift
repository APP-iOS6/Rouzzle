//
//  AddTaskView.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/6/24.
//

import SwiftUI
import SwiftData
import Factory

struct AddTaskView: View {
    @Binding var path: NavigationPath // 상위 뷰로부터 바인딩
    @Environment(\.modelContext) private var modelContext
    @Environment(RoutineStore.self) private var routineStore
    @State private var isShowingAddTaskSheet: Bool = false
    @State private var isShowingTimerView: Bool = false
    @State private var isShowingRoutineSettingsSheet: Bool = false
    @State private var isShowingEditRoutineSheet: Bool = false
    @State private var isShowingDeleteAlert = false
    @State private var isShowingTimeBasedView: Bool = false
    @State var selectedCategory: RoutineCategoryByTime?
    @State private var toast: ToastModel?
    @State private var detents: Set<PresentationDetent> = [.fraction(0.12)]
    
    @Environment(\.dismiss) private var dismiss
    let completeAction: (String) -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack(alignment: .bottom) {
                    Label(routineStore.todayStartTime, systemImage: "clock")
                        .font(.medium16)
                        .foregroundStyle(Color.subHeadlineFontColor)
                        .padding(.top, 15)
                    
                    Spacer()
                    
                    Button {
                        isShowingAddTaskSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title)
                    }
                }
                .padding(.bottom, 5)
                
                if routineStore.taskList.isEmpty {
                    HStack {
                        Text("🧩")
                            .font(.bold40)
                        
                        Text("할 일을 추가해 보세요")
                            .font(.medium16)
                            .padding(.leading, 10)
                        
                        Spacer()
                        
                        Text("example")
                            .font(.medium14)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(RoundedRectangle(cornerRadius: 15).fill(.secondcolor))
                    }
                    .padding(.horizontal, 25)
                    .padding(.vertical, 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(style: StrokeStyle(lineWidth: 1))
                            .foregroundStyle(.grayborderline)
                    )
                } else {
                    ForEach(routineStore.taskList) { task in
                        TaskStatusPuzzle(task: task)
                    }
                }
                
                RouzzleButton(buttonType: .timerStart, disabled: routineStore.taskList.isEmpty) {
                    isShowingTimerView.toggle()
                }
                .padding(.top)
                
                HStack {
                    Text("추천 할 일")
                        .font(.bold18)
                    
                    Spacer()
                    
                    Button {
                        routineStore.getRecommendTask()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.title3)
                    }
                }
                .padding(.top, 30)
                
                // 추천 리스트
                if routineStore.recommendTodoTask.isEmpty {
                    Text("추천 할 일을 모두 등록했습니다!")
                        .font(.regular16)
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 20)
                } else {
                    VStack(spacing: 10) {
                        ForEach(routineStore.recommendTodoTask, id: \.self) { recommend in
                            TaskRecommendPuzzle(recommendTask: recommend) {
                                routineStore.getRecommendTask()
                                Task {
                                    await routineStore.addTask(recommend, context: modelContext)
                                }
                            }
                        }
                    }
                    .animation(.smooth, value: routineStore.recommendTodoTask)
                }
                HStack(alignment: .bottom) {
                    Text("추천 세트")
                        .font(.bold18)
                    
                    Spacer()
                    
                    Text("테마별 추천 할 일을 모아놨어요!")
                        .font(.regular12)
                        .foregroundStyle(Color.subHeadlineFontColor)
                }
                .padding(.top, 30)
                
                HStack(spacing: 14) {
                    ForEach(RoutineCategoryByTime.allCases, id: \.self) { category in
                        Button {
                            selectedCategory = category
                        } label: {
                            Text(category.rawValue)
                                .font(.semibold16)
                                .foregroundStyle(.black)
                                .frame(width: 82, height: 46)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.fromRGB(r: 239, g: 239, b: 239), lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(.top, 10)
            }
            .padding(.bottom, 20)
            .customNavigationBar(title: "\(routineStore.routineItem!.emoji) \(routineStore.routineItem!.title)")
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
        }
        .padding()
        .toastView(toast: $toast) // ToastModifier 적용
        .customAlert(
            isPresented: $isShowingDeleteAlert,
            title: "해당 루틴을 삭제합니다",
            message: "삭제 버튼 선택 시, 루틴 데이터는\n삭제되며 복구되지 않습니다.",
            primaryButtonTitle: "삭제",
            primaryAction: {
                routineStore.deleteRoutine(
                    modelContext: modelContext,
                    completeAction: completeAction,
                    dismiss: { dismiss() }
                )
                dismiss()
            }
        )
        .fullScreenCover(item: $selectedCategory) { category in
            TimeBasedRecommendSetView(category: category) { tasks in
                Task {
                    await routineStore.addTasks(tasks, context: modelContext)
                }
            }
        }
        .fullScreenCover(isPresented: $isShowingTimerView) {
            RoutineStartView(
                viewModel: RoutineStartStore(
                    routineItem: routineStore.routineItem!
                ),
                path: $path
            )
        }
        .fullScreenCover(isPresented: $isShowingEditRoutineSheet) {
            EditRoutineView(viewModel: EditRoutineViewModel(routine: routineStore.routineItem!)) { _ in
                routineStore.loadState = .completed
                routineStore.toastMessage = "수정에 성공했습니다."
                routineStore.fetchViewTask()
            }
        }
        .sheet(isPresented: $isShowingAddTaskSheet) {
            NewTaskSheet(detents: $detents) { task in
                Task {
                    await routineStore.addTask(task, context: modelContext)
                }
            }
            .presentationDetents(detents)
        }
        .sheet(isPresented: $isShowingRoutineSettingsSheet) {
            RoutineSettingsSheet(
                isShowingEditRoutineSheet: $isShowingEditRoutineSheet,
                isShowingDeleteAlert: $isShowingDeleteAlert
            )
            .presentationDetents([.fraction(0.25)])
        }
        .overlay {
            if routineStore.loadState == .loading {
                ProgressView()
            }
        }
        .onChange(of: routineStore.toastMessage) { _, new in
            guard let new else {
                return
            }
            if routineStore.loadState == .completed {
                toast = ToastModel(type: .success, message: new)
                routineStore.toastMessage = nil
            } else {
                toast = ToastModel(type: .warning, message: new)
                routineStore.toastMessage = nil
            }
        }
        .onAppear {
            routineStore.getRecommendTask()
        }
        .animation(.smooth, value: routineStore.taskList)
    }
}

#Preview {
    NavigationStack {
        AddTaskView(path: .constant(NavigationPath()), completeAction: {_ in })
            .modelContainer(SampleData.shared.modelContainer)
            .environment(RoutineStore())
    }
}
