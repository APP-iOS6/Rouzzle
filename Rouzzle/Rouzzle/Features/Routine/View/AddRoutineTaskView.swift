//
//  AddRoutineTaskView.swift
//  Rouzzle
//
//  Created by 김동경 on 11/15/24.
//

import SwiftUI

struct AddRoutineTaskView: View {
    
    @Bindable var viewModel: AddRoutineViewModel
    @State var routineByTime: RoutineCategoryByTime?
    @State private var isCustomTaskSheet: Bool = false
    @State private var detents: Set<PresentationDetent> = [.fraction(0.12)]
    @Environment(\.modelContext) private var context

    var body: some View {
        GeometryReader { proxy in
            VStack {
                ScrollView {
                    VStack {
                        // 선택된 할 일 리스트 섹션
                        SelectedTaskListView(
                            selectedTask: $viewModel.routineTask,
                            minHeight: proxy.size.height * 0.3
                        )
                        .padding(.bottom, 20)
                        
                        // 추천 할 일 섹션
                        RecommendTaskListView(recommendTask: $viewModel.recommendTodoTask) {
                            viewModel.getRecommendTask()
                        } taskAppend: { routineTask in
                            if let index = viewModel.routineTask.firstIndex(where: { $0.hashValue == routineTask.hashValue }) {
                                viewModel.routineTask.remove(at: index)
                            } else {
                                viewModel.routineTask.append(routineTask)
                            }
                            viewModel.getRecommendTask()
                        }
                        
                        // 추천 세트 할일 섹션
                        HStack {
                            Text("추천 세트")
                                .font(.bold18)
                            
                            Spacer()
                            
                            Text("테마별 추천 할 일을 모아놨어요!")
                                .font(.regular12)
                                .foregroundStyle(Color.subHeadlineFontColor)
                        }
                        .padding(.top, 20)
                        
                        HStack(spacing: 14) {
                            ForEach(RoutineCategoryByTime.allCases, id: \.self) { category in
                                Button {
                                    routineByTime = category
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
                            .padding(.top, 10)
                        }
                        .padding(.bottom, 20)
                    }
                    .padding()
                }
                Button {
                    isCustomTaskSheet.toggle()
                } label: {
                    Text("추가")
                        .font(.bold20)
                        .modifier(BorderButtonModifier())
                }
                .padding(.horizontal)
                
                RouzzleButton(buttonType: .save) {
                    viewModel.uploadRoutine(context: context)
                }
                .padding(.horizontal)
            }
            .sheet(isPresented: $isCustomTaskSheet) {
                NewTaskSheet(detents: $detents) { task in
                    viewModel.routineTask.append(task.toRoutineTask())
                }
                .presentationDetents(detents)
            }
            .fullScreenCover(item: $routineByTime) { category in
                TimeBasedRecommendSetView(category: category) { recommend in
                    for task in recommend {
                        viewModel.routineTask.append(task.toRoutineTask())
                    }
                }
            } // endFullScreenCover
        }
    }
}

struct SelectedTaskListView: View {
    
    @State private var showDeleteIcon = false
    @State private var draggedItem: RoutineTask?
    @Binding var selectedTask: [RoutineTask]
    let minHeight: CGFloat
    
    var body: some View {
        VStack(spacing: 14) {
            if selectedTask.isEmpty {
                Text("할 일을 추가해 주세요!")
                    .frame(maxWidth: .infinity, minHeight: minHeight, alignment: .center)
                    .foregroundStyle(.gray)
            } else {
                HStack {
                    Text("목록 수정")
                        .font(.semibold18)
                        .padding(.leading, 14)
                    
                    Spacer()
                    
                    // 삭제 버튼
                    Button {
                        showDeleteIcon.toggle()
                    } label: {
                        // 삭제버튼 눌렸을 때, 목록이동이미지->삭제버튼
                        Image(systemName: showDeleteIcon ? "arrow.up.arrow.down" : "trash")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 14)
                }
                
                ForEach(selectedTask, id: \.self) { task in
                    if showDeleteIcon {
                        TaskStatusRow(
                            taskStatus: .pending,
                            emojiText: task.emoji,
                            title: task.title,
                            timeInterval: task.timer,
                            showEditIcon: .constant(false),
                            showDeleteIcon: $showDeleteIcon
                        ) {
                            selectedTask.removeAll(where: { $0.hashValue == task.hashValue })
                        }
                    } else {
                        TaskStatusRow(
                            taskStatus: .pending,
                            emojiText: task.emoji,
                            title: task.title,
                            timeInterval: task.timer,
                            showEditIcon: .constant(true),
                            showDeleteIcon: $showDeleteIcon
                        )
                        .onDrag {
                            draggedItem = task
                            return NSItemProvider()
                        }
                        .onDrop(of: [.text], delegate: AddTaskDropDelegate(item: task, items: $selectedTask, draggedItem: $draggedItem))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: minHeight, alignment: .top)
        .animation(.smooth, value: selectedTask)
    }
}

struct RecommendTaskListView: View {
    
    @Binding var recommendTask: [RecommendTodoTask]
    let refreshRecommend: () -> Void
    let taskAppend: (RoutineTask) -> Void
    var body: some View {
        HStack {
            Text("추천 할 일")
                .font(.semibold18)
            Spacer()
            Button {
                refreshRecommend()
            } label: {
                Image(systemName: "arrow.clockwise")
                    .font(.title3)
            }
        }
        
        VStack(spacing: 10) {
            ForEach(recommendTask, id: \.self) { recommend in
                TaskRecommendPuzzle(recommendTask: recommend) {
                    taskAppend(recommend.toRoutineTask())
                }
            }
        }
        .animation(.smooth, value: recommendTask)
        
    }
}

private struct AddTaskDropDelegate: DropDelegate {
    let item: RoutineTask
    @Binding var items: [RoutineTask]
    @Binding var draggedItem: RoutineTask?
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedItem,
              draggedItem.hashValue != item.hashValue,
              let fromIndex = items.firstIndex(where: { $0.hashValue == draggedItem.hashValue }),
              let toIndex = items.firstIndex(where: { $0.hashValue == item.hashValue }) else { return }
        
        withAnimation {
            items.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
        }
    }
}

#Preview {
    AddRoutineTaskView(viewModel: .init())
}
