//
//  SocialViewModel.swift
//  Rouzzle
//
//  Created by 김정원 on 11/13/24.
//

import Foundation
import Observation
import Factory
import FirebaseAuth

@Observable
class SocialViewModel {
    @ObservationIgnored
    @Injected(\.socialService) private var socialService
    
    var otherUserProfiles = Set<UserProfile>()
    var userFavorites = Set<UserProfile>()
    var error: DBError?
    var currentUserProfile: UserProfile?
    
    init() {
        Task {
            await fetchUserProfiles()
        }
    }
    
    // 사용자 프로필 가져오기
    @MainActor
    func fetchUserProfiles() async {
        do {
            // 모든 사용자 프로필 불러오기
            let allProfiles = try await socialService.fetchUserInfo()
            
            // 현재 사용자의 프로필을 별도로 저장
            if let currentUser = allProfiles.first(where: { $0.documentId == Utils.getUserUUID() }) {
                self.currentUserProfile = currentUser
            }
            
            // 다른 사용자 프로필 설정 (현재 사용자 제외)
            self.otherUserProfiles = Set(allProfiles.filter {
                !$0.routines.isEmpty && $0.documentId != Utils.getUserUUID()
            })
            
            // 즐겨찾기 업데이트
            fetchFavoritesUser()
            print("유저 프로필 \(otherUserProfiles)")
        } catch {
            print("Error fetching user profiles: \(error)")
        }
    }
    
    // 좋아요한 유저 프로필 가져오기
    private func fetchFavoritesUser() {
        guard let currentUserProfile = self.currentUserProfile else {
            self.userFavorites = []
            return
        }
        let favoriteIDs = currentUserProfile.isFavoriteUser ?? []
        let favoriteProfiles = otherUserProfiles.filter { profile in
            favoriteIDs.contains(profile.documentId ?? "")
        }
        self.userFavorites = Set(favoriteProfiles)
    }
    
    // 좋아요 추가/삭제
    @MainActor
    func toggleFavoriteUser(userID: String) async {
        do {
            if isUserFavorited(userID: userID) {
                try await socialService.deleteFavoriteUser(userID: userID)
                userFavorites.remove(otherUserProfiles.filter({ $0.documentId == userID }).first!)
                print("User \(userID) removed from favorites.")
            } else {

                try await socialService.addFavoriteUser(userID: userID)
                userFavorites.insert(otherUserProfiles.filter({ $0.documentId == userID }).first!)
                print("User \(userID) added to favorites.")
            }
        } catch {
            print("Error toggling favorite user: \(error)")
        }
    }
    
    // 즐겨찾기 여부 확인
    func isUserFavorited(userID: String) -> Bool {
        return userFavorites.contains(where: { $0.documentId == userID })
    }
}
