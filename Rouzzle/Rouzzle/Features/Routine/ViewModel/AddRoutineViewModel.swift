//
//  AddRoutineViewModel.swift
//  Rouzzle
//
//  Created by 김동경 on 11/8/24.
//

import Factory
import Foundation
import Observation

@Observable
class AddRoutineViewModel {
    
    @ObservationIgnored
    @Injected(\.routineService) private var routineService
    
    
    func uploadRoutine() {
        
    }
}
