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
import AlgoliaSearchClient
import FirebaseFirestore

@Observable
class SocialViewModel {
    @ObservationIgnored
    @Injected(\.socialService) private var socialService
    
    var otherUserProfiles = Set<UserProfile>()
    var userFavorites = Set<UserProfile>()
    var error: DBError?
    var currentUserProfile: UserProfile?
    
    // 알고리아 클라이언트 및 인덱스 설정
    private let client: SearchClient
    private let index: Index
    
    var searchResults: [RoutineUser] = [] // 검색 결과 저장
    
    init() {
        self.client = SearchClient(appID: "DZ28XG6P3C", apiKey: "cc69c3a6cc67b834103ad7d1aa312a50")
        self.index = client.index(withName: "User")
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
    
    // 검색 수행
    func performSearch(query: String) {
        index.search(query: "\(query)") { result in
            switch result {
            case .failure(let error):
                print("Error: \(error)")
            case .success(let response):
                print("Response: \(response.hits)")
                do {
                    // Algolia 결과를 AlgoliaUser로 디코딩
                    let algoliaResults = try response.extractHits() as [AlgoliaUser]
                    
                    // AlgoliaUser를 RoutineUser로 변환
                    self.searchResults = algoliaResults.map { algoliaUser in
                        RoutineUser(
                            id: algoliaUser.id,
                            name: algoliaUser.name,
                            profileUrlString: algoliaUser.profileUrlString,
                            introduction: algoliaUser.introduction
                        )
                    }
                    print("✅ Updated searchResults: \(self.searchResults)")
                } catch let error {
                    print("⛔️ Contact parsing error: \(error)")
                    self.searchResults = []
                }
            }
        }
    }
    
    func fetchRoutines(for userId: String) async -> [Routine] {
        do {
            let snapshot = try await Firestore.firestore()
                .collection("Routine")
                .whereField("userId", isEqualTo: userId)
                .getDocuments()
            
            let routines = snapshot.documents.compactMap { document -> Routine? in
                try? document.data(as: Routine.self)
            }
            return routines
        } catch {
            print("Error fetching routines for user \(userId): \(error.localizedDescription)")
            return []
        }
    }
}
