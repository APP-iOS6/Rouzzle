//
//  RoutineListViewModel.swift
//  Rouzzle
//
//  Created by 김동경 on 11/23/24.
//

import Factory
import Foundation
import Observation
import SwiftData

@Observable
class RoutineListViewModel {
    
    @ObservationIgnored
    @Injected(\.routineService) private var routineService
    
    var phase: Phase = .loading
    var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
        Task {
            await loadUserRoutineData()
        }
    }
    
    @MainActor
    func loadUserRoutineData() async {
        phase = .loading
        let userUid = Utils.getUserUUID()
        let result =  await routineService.getMyRoutineInfo(userUid)
    
        switch result {
        case let .success(routineWithCompletion):
            do {
                try SwiftDataService.deleteAllRoutines(for: userUid, context: context)
                for data in routineWithCompletion {
                    let routine = data.routine.toRoutineItem()
                    try SwiftDataService.addRoutine(routine, context: context)
                    for task in data.completion.taskCompletions {
                        if let routineTask = data.routine.routineTask.first(where: { $0.title == task.title }) {
                            let taskList = TaskList(title: routineTask.title, emoji: routineTask.emoji, timer: routineTask.timer, isCompleted: task.isComplete)
                            try SwiftDataService.addTask(to: routine, taskList, context: context)
                        }
                    }
                }
                print("루초 성공")
                phase = .completed
            } catch {
                print("루초 실패")
                phase = .failed
            }
        case .failure:
            print("루초 실패")
            phase = .failed
        }
    }
}
