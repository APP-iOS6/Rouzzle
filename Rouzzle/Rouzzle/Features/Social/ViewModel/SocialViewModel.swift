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
            await fetchFavoritesUser()
            print("유저 프로필 \(otherUserProfiles)")
        } catch {
            await MainActor.run {
                self.error = DBError.firebaseError(error)
            }
            print("Error fetching user profiles: \(error)")
        }
    }
    
    // 좋아요한 유저 프로필 가져오기
    @MainActor
    func fetchFavoritesUser() async {
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
                // 서버에만 반영하고 로컬 데이터는 업데이트하지 않음
                try await socialService.deleteFavoriteUser(userID: userID)
                print("User \(userID) removed from favorites.")
            } else {
                // 서버에만 반영하고 로컬 데이터는 업데이트하지 않음
                try await socialService.addFavoriteUser(userID: userID)
                print("User \(userID) added to favorites.")
            }
            // 로컬 데이터 업데이트는 하지 않음
        } catch {
            await MainActor.run {
                self.error = DBError.firebaseError(error)
            }
            print("Error toggling favorite user: \(error)")
        }
    }
    
    // 즐겨찾기 여부 확인
    func isUserFavorited(userID: String) -> Bool {
        return userFavorites.contains(where: { $0.documentId == userID })
    }
}
