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
    
    var error: DBError?
    var nicknameToRoutines: [String: [Routine]] = [:] // nickname: [Routine]

    @MainActor
    func fetchUsersAndRoutines() async {
        do {
            async let usersTask = socialService.fetchAllUserNicknames() // 닉네임 : UUID
            async let routinesTask = socialService.fetchRoutinesGroupedByUser() // UUID: 루틴
            
            let (users, routines) = try await (usersTask, routinesTask)
            
            var mapping: [String: [Routine]] = [:]
            
            for (userID, routinesList) in routines {
                if let nickname = users[userID] {
                    mapping[nickname, default: []] += routinesList
                } else {
                    mapping["Unknown", default: []] += routinesList
                }
            }
            self.nicknameToRoutines = mapping
        } catch {
            self.error = DBError.firebaseError(error)
        }
    }
    
}
