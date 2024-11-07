//
//  TaskListSheet.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/7/24.
//

import SwiftUI

struct TaskListSheet: View {
    @State private var tasks = DummyTask.tasks
    @State private var draggedItem: DummyTask?
    
    var body: some View {
        VStack(spacing: 35) {
            Text("할일 목록")
                .font(.semibold20)
                .padding(.top, 30)
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(tasks) { task in
                        TaskStatusRow(taskStatus: task.taskStatus,
                                         emojiText: task.emojiText,
                                         title: task.title)
                        .onDrag {
                            self.draggedItem = task
                            return NSItemProvider()
                        }
                        .onDrop(of: [.text],
                                delegate: DropViewDelegate(item: task, items: $tasks, draggedItem: $draggedItem))
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Text("순서 수정")
                    .underline()
                    .font(.regular18)
            }
            .padding(.bottom, 10)
        }
    }
}

struct DropViewDelegate: DropDelegate {
    
    let item: DummyTask
    @Binding var items: [DummyTask]
    @Binding var draggedItem: DummyTask?
    
    // 드래그 할 때 아이템 우측 상단에 표시되는 이미지 설정 (이 매서드 아예 안쓰면 기본 값 copy : + 플러스 이미지)
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move) // move, cancel 은 이미지 안나옴. forbidden 는 ⛔︎ 이런 이미지 나옴
    }
    
    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedItem,
              draggedItem.id != item.id,
              let toIndex = items.firstIndex(where: { $0.id == item.id }),
              let fromIndex = items.firstIndex(where: { $0.id == draggedItem.id }) else { return }
        
        withAnimation {
            items.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
        }   
    }
}

// MARK: - 테스트용 더미 데이터
struct DummyTask: Identifiable {
    let id = UUID()
    let taskStatus: TaskStatus
    let emojiText: String
    let title: String
    
    static var tasks = [
        DummyTask(taskStatus: .completed, emojiText: "☕️", title: "커피/차 마시기"),
        DummyTask(taskStatus: .inProgress, emojiText: "💊", title: "유산균 먹기"),
        DummyTask(taskStatus: .pending, emojiText: "🧼", title: "설거지 하기"),
        DummyTask(taskStatus: .pending, emojiText: "👕", title: "옷 갈아입기")
    ]
}

#Preview {
    TaskListSheet()
}
