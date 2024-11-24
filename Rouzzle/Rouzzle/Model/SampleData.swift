//
//  SampleData.swift
//  Rouzzle
//
//  Created by 김정원 on 11/10/24.
//

import Foundation
import SwiftData

@MainActor
class SampleData {
    static let shared = SampleData()
    let modelContainer: ModelContainer
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    private init() {
        let schema = Schema([
            RoutineItem.self,
            TaskList.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            insertSampleData()
            try context.save()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    private func insertSampleData() {
        for routine in RoutineItem.sampleData {
            context.insert(routine)
            
            let tasks = TaskList.sampleData
            for task in tasks {
                context.insert(task)
                routine.taskList.append(task) // Add the task to the routine’s taskList
            }
        }
    }
}
