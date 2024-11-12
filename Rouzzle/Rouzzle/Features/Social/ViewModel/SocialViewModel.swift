//
//  SocialViewModel.swift
//  Rouzzle
//
//  Created by 김정원 on 11/13/24.
//

import Foundation
import Observation
import Factory

@Observable
class SocialViewModel {
    @ObservationIgnored
    @Injected(\.socialService) private var socialService
    
    var routinesByUser: [String: [Routine]] = [:]
    var error: DBError?

    @MainActor
    func fetchRoutines() async {
        do {
            let groupedRoutines = try await socialService.fetchRoutinesGroupedByUser()
            self.routinesByUser = groupedRoutines
        } catch {
            self.error = DBError.firebaseError(error)
        }
    }
}
