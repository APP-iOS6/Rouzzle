//
//  TaskListSheet.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/7/24.
//

import SwiftUI

struct TaskListSheet: View {
    // @State var viewModel: RoutineStartViewModel
    @Binding var tasks: [TaskList] // viewTasks
    @Binding var detents: Set<PresentationDetent>
    @State private var draggedItem: TaskList?
    @State private var showEditIcon = false
    var inProgressTask: TaskList?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 35) {
            Text(showEditIcon ? "목록 수정" : "할일 목록")
                .font(.semibold20)
                .padding(.top, 30)
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(tasks) { task in
                        if showEditIcon {
                            // 순서 수정 버튼 눌렀을 때
                            TaskStatusRow(
                                taskStatus: task.isCompleted ? .completed : .pending,
                                emojiText: task.emoji,
                                title: task.title,
                                timeInterval: task.timer,
                                showEditIcon: $showEditIcon,
                                showDeleteIcon: .constant(false),
                                onDelete: {
                                    // onDelete(task)
                                }
                            )
                            .onDrag {
                                self.draggedItem = task
                                return NSItemProvider()
                            }
                            .onDrop(
                                of: [.text],
                                delegate: DropViewDelegate(
                                    item: task,
                                    items: $tasks,
                                    draggedItem: $draggedItem
                                )
                            )
                        } else {
                            // 순서 수정 버튼 안 눌렀을 때
                            TaskStatusRow(
                                taskStatus: task.id == inProgressTask?.id ? .inProgress :
                                    (task.isCompleted ? .completed : .pending),
                                emojiText: task.emoji,
                                title: task.title,
                                timeInterval: task.timer,
                                showEditIcon: $showEditIcon,
                                showDeleteIcon: .constant(false)
                            )
                        }
                    }
                }
                .padding()
            }
            
            Spacer()
            
            if showEditIcon {
                Button {
                    dismiss()
                } label: {
                    Text("완료")
                        .underline()
                        .font(.regular18)
                }
                .padding(.bottom, 20)
            } else {
                Button {
                    showEditIcon.toggle()
                } label: {
                    Text("순서 수정")
                        .underline()
                        .font(.regular18)
                }
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            updateDetents()
        }
    }
    
    private func updateDetents() {
        // tasks의 개수에 따라 detents 값 조정
        let fraction = min(0.5 + 0.1 * max(0, Double(tasks.count - 2)), 0.9)
        detents = [.fraction(fraction)]
    }
}

struct DropViewDelegate: DropDelegate {
    let item: TaskList
    @Binding var items: [TaskList]
    @Binding var draggedItem: TaskList?
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedItem,
              draggedItem.id != item.id,
              let fromIndex = items.firstIndex(where: { $0.id == draggedItem.id }),
              let toIndex = items.firstIndex(where: { $0.id == item.id }) else { return }
        
        withAnimation {
            items.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
        }
    }
}

// #Preview {
//    TaskListSheet(detents: .constant([.fraction(0.12)]))
// }
