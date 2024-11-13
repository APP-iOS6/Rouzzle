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
    var userProfiles: [OtherUserProfile] = []
    var error: DBError?
    var nicknameToRoutines: [String: [Routine]] = [:] // nickname: [Routine]
    
    @MainActor
    func fetchUserProfiles() async {
        do {
            // 닉네임 맵과 루틴을 가져오기
            let idToNameMap = try await socialService.fetchAllUserNicknames()
            let groupedRoutines = try await socialService.fetchRoutinesGroupedByUser()
            
            // 각 유저의 프로필 이미지, 닉네임, 루틴을 포함하여 UserProfile 생성
            var profiles: [OtherUserProfile] = []
            for (userID, routines) in groupedRoutines {
                if let nickname = idToNameMap[userID] {
                    let profileImageUrl = try await socialService.fetchUserProfileImage(userID: userID)
                    let userProfile = OtherUserProfile(
                        userID: userID,
                        nickname: nickname,     // 닉네임 설정
                        profileImageUrl: profileImageUrl,
                        routines: routines
                    )
                    profiles.append(userProfile)
                } else {
                    print("UserID \(userID) does not have a corresponding nickname.")
                }
            }
            
            self.userProfiles = profiles
        } catch {
            print("Error fetching user profiles: \(error)")
            
        }
    }
}

struct OtherUserProfile: Identifiable {
    var id = UUID()
    var userID: String
    var nickname: String
    var profileImageUrl: String
    var routines: [Routine]
}
