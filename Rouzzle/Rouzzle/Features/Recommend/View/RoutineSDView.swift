//
//  RoutineSDView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/8/24.
//

import SwiftUI
import SwiftData

struct RoutineSDView: View {
    @Query private var routines: [RoutineItem]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    do {
                        try SwiftDataService.addRoutine(RoutineItem(id: UUID().uuidString, title: "운동 루틴", emoji: "💪🏻", dayStartTime: [1: "06:30", 2: "07:30"]), context: modelContext)
                    } catch {
                        print("실패")
                    }
                } label: {
                    Text("운동 루틴 생성 ")
                }
                Button {
                    do {
                        try SwiftDataService.addRoutine(RoutineItem(id: UUID().uuidString, title: "점심 루틴", emoji: "☀️", dayStartTime: [1: "12:30", 2: "05:00"]), context: modelContext)
                    } catch {
                        print("실패")
                    }
                } label: {
                    Text("점심 루틴 생성 ")
                }
                
                List {
                    ForEach(routines) { routine in
                        NavigationLink(destination: RoutineDetailView(routineItem: routine)) {
                            HStack {
                                Text(routine.emoji)
                                Text(routine.title)
                                    .font(.headline)
                                Spacer()
                                Text(routine.dayStartTime[2] ?? "00:00")
                                
                            }
                        }
                    }
                    .onDelete(perform: deleteRoutine)
                }
            }
        }
    }
    
    private func deleteRoutine(at offsets: IndexSet) {
        for index in offsets {
            let routine = routines[index]
            do {
                try SwiftDataService.deleteRoutine(routine: routine, context: modelContext)
            } catch {
                print("루틴 삭제 에러: \(error)")
            }
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
                    
                    Toggle("완료", isOn: Binding(
                        get: { task.isCompleted },
                        set: { newValue in
                            task.isCompleted = newValue
                            saveChanges() // Save changes each time toggle is used
                        }
                    ))
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
    
    private func saveChanges() {
        do {
            try modelContext.save()
        } catch {
            print("상태 저장 실패: \(error)")
        }
    }
}
struct AddTodoTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Bindable var routineItem: RoutineItem

    @State private var title: String = ""
    @State private var emoji: String = ""
    @State private var timer: String = ""

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
    private func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            let task = routineItem.taskList[index]
            do {
                try SwiftDataService.deleteTask(task: task, context: modelContext)
            } catch {
                print("할 일 제거 에러: \(error)")
            }
        }
    }
}

#Preview {
    RoutineSDView()
    
}
