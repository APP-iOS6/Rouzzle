//
//  RoutineStore.swift
//  Rouzzle
//
//  Created by 김동경 on 11/7/24.
//

import Foundation
import Factory
import Observation

@Observable
class RoutineStore {
    var routineItem: RoutineItem
    
    
    init(routineItem: RoutineItem) {
        self.routineItem = routineItem
    }
    
    
    func getRecommendTask() {
        guard let firstTime = routineItem.dayStartTime.first?.value, let time = firstTime.toDate() else {
           return
        }
        
        switch time.getTimeCategory() {
        case .morning:
            return
        case .afternoon:
            return
        case .evening:
            return
        case .night:
            return
        }
    }
    
}
