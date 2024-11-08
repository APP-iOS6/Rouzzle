//
//  RecommendView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import SwiftUI
import SwiftData
struct RecommendView: View {
    @Query private var routines: [RoutineItem]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    do {
                        try SwiftDataService.addRoutine(RoutineItem(title: "아침", emoji: "ㅇ", dayStartTime: [1: .now]), context: modelContext)
                    } catch {
                        print("실패")
                    }
                } label: {
                    Text("모델 더미데이터 생성용")
                }
                List {
                    ForEach(routines) { routine in
                        NavigationLink(destination: RoutineDetailView(routineItem: routine)) {
                            VStack(alignment: .leading) {
                                Text(routine.title)
                                    .font(.headline)
                            }
                        }
                    }
                    .onDelete(perform: deleteRoutine)
                }
            }
        }
    }
    private func deleteRoutine(at offsets: IndexSet) {
        let routineToDelete = offsets.map { routines[$0] }
        for routine in routineToDelete {
            modelContext.delete(routine)
        }
        do {
            try modelContext.save()
        } catch {
            print("할 일 삭제 실패: \(error)")
        }
    }
}

struct RoutineDetailView: View {
    @Bindable var routineItem: RoutineItem
    @Environment(\.modelContext) private var modelContext
    @State private var showingAddTask = false

    var body: some View {
        List {
            ForEach(routineItem.taskList) { task in
                HStack {
                    Text(task.emoji)
                    Text(task.title)
                    Spacer()
                    Text("\(String(describing: task.timer))분")
                }
            }
            .onDelete(perform: deleteTask)
        }
        .navigationTitle(routineItem.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddTask.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddTodoTaskView(routineItem: routineItem)
        }
    }

    private func deleteTask(at offsets: IndexSet) {
        let tasksToDelete = offsets.map { routineItem.taskList[$0] }
        for task in tasksToDelete {
            modelContext.delete(task)
        }
        do {
            try modelContext.save()
        } catch {
            print("할 일 삭제 실패: \(error)")
        }
    }
}
struct AddTodoTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Bindable var routineItem: RoutineItem

    @State private var title: String = ""
    @State private var emoji: String = ""
    @State private var timer: String = "" // 문자열로 받아서 입력 검증

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("할 일 제목")) {
                    TextField("제목을 입력하세요", text: $title)
                }
                Section(header: Text("이모지")) {
                    TextField("이모지를 입력하세요", text: $emoji)
                }
                Section(header: Text("타이머 (분)")) {
                    TextField("시간을 입력하세요", text: $timer)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("새 할 일 추가")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        do {
                            try SwiftDataService.addTask(to: routineItem, TaskList(title: title, emoji: emoji, timer: Int(timer)!), context: modelContext)
                        } catch {
                            print("실패")
                        }
                        dismiss()
                    }
                    .disabled(title.isEmpty || emoji.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func saveTask() {
        guard let timerValue = Int(timer) else { return }
        let newTask = TaskList(
            title: title,
            emoji: emoji,
            timer: timerValue
        )
        modelContext.insert(newTask)
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("할 일 저장 실패: \(error)")
        }
    }
}

#Preview {
    RecommendView()
}
