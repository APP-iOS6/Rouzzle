//
//  AddTaskView.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/6/24.
//

import SwiftUI
import SwiftData

struct AddTaskView: View {
    var routineItem: RoutineItem
    @Environment(\.modelContext) private var modelContext
    @State private var taskList: [TaskList]
    @State var isShowingAddTaskSheet: Bool = false
    @State var isShowingTimerView: Bool = false
    @State var isShowingRoutineSettingsSheet: Bool = false
    @State private var detents: Set<PresentationDetent> = [.fraction(0.12)]

    init(routineItem: RoutineItem) {
        self.routineItem = routineItem
        self.taskList = routineItem.taskList
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Label("08:00 AM", systemImage: "clock")
                        .font(.regular16)
                        .foregroundStyle(Color.subHeadlineFontColor)
                        .padding(.top, 10)
                    
                    Button {
                        isShowingTimerView.toggle()
                    } label: {
                        Image(.routineStart)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .padding(.top, 5)
                
                    ForEach(taskList) { task in
                        TaskStatusPuzzle(task: task)
                    }
                    .id(routineItem)
                    
                    HStack {
                        Text("추천 할 일")
                            .font(.bold18)
                        
                        Spacer()
                        
                        Button {
                            
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
                    
                    VStack(spacing: 10) {
                        TaskRecommendPuzzle { task in
                            addTaskToRoutine(task)
                        }
                        TaskRecommendPuzzle { task in
                            addTaskToRoutine(task)
                        }
                        TaskRecommendPuzzle { task in
                            addTaskToRoutine(task)
                        }
                    }
                    
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
                            NavigationLink(destination: TimeBasedRecommendSetView(category: category)) {
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
                .customNavigationBar(title: "☀️ 아침 루틴")
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
                    RoutineStartView()
                }
                .sheet(isPresented: $isShowingAddTaskSheet) {
                    NewTaskSheet(detents: $detents) {
                        // 할 일 추가 버튼 로직
                    }
                    .presentationDetents(detents)
                }
                .sheet(isPresented: $isShowingRoutineSettingsSheet) {
                    RoutineSettingsSheet()
                        .presentationDetents([.fraction(0.25)])
                }
            }
            
            FloatingButton {
                isShowingAddTaskSheet.toggle()
            }
            .padding()
        }
    }
    // Task를 추가하는 함수
    private func addTaskToRoutine(_ task: RecommendTodoTask) {
        let newTask = TaskList(title: task.title, emoji: task.emoji, timer: Int(exactly: task.timer)!)
        do {
            try SwiftDataService.addTask(to: routineItem, newTask, context: modelContext)
            taskList.append(newTask)
        } catch {
            print("할일 추가 실패")
        }
    }
}

#Preview {
    NavigationStack {
        AddTaskView(routineItem: RoutineItem.sampleData[0])
            .modelContainer(SampleData.shared.modelContainer)
    }
}
