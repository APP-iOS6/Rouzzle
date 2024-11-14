//
//  RecommendSheet.swift
//  Rouzzle
//
//  Created by 김동경 on 11/14/24.
//

import SwiftUI
import SwiftData

struct RecommendSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var routines: [RoutineItem]
    let tasks: [RecommendTodoTask]
    let saveRoutine: (RoutineItem?) -> Void
    @State private var selectedRoutineId: String?
    var selectedRoutine: RoutineItem? {
        routines.first(where: { $0.id == selectedRoutineId })
    }
    
    init(
        tasks: [RecommendTodoTask],
        saveRoutine: @escaping (RoutineItem?) -> Void) {
        self.tasks = tasks
        self.saveRoutine = saveRoutine
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text("닫기")
                        .font(.semibold18)
                }
                Spacer()
                Button {
                    saveRoutine(selectedRoutine)
                    dismiss()
                } label: {
                    Text("완료")
                        .font(.semibold18)
                }
            }
            .padding()
            Picker(selection: $selectedRoutineId, label: Text("루틴 선택")) {
                ForEach(routines) { routine in
                    Text(routine.title).tag(Optional(routine.id))
                        .font(.semibold20)
                        .padding()
                }
                Text("루틴 추가하기").tag(nil as String?)
            }
            .pickerStyle(.wheel)
        }
        .onAppear {
            selectedRoutineId = routines.first?.id ?? nil
        }
    }
}

#Preview {
    RecommendSheet(tasks: []) { _ in}
}
