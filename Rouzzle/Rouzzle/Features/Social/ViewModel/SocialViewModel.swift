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
    var userProfiles: [UserProfile] = []
    var userFavorites: [UserProfile] {
        let favoriteIDs = userProfiles
            .first(where: { $0.documentId == Auth.auth().currentUser?.uid ?? Utils.getDeviceUUID() })?
            .isFavoriteUser ?? []
        
        let favoriteProfiles = userProfiles.filter { profile in
            favoriteIDs.contains(profile.documentId ?? "")
        }
        return favoriteProfiles
    }
    var error: DBError?
    
    init() {
        Task {
            await fetchUserProfiles()
        }
    }
    
    @MainActor
    func fetchUserProfiles() async {
        do {
            self.userProfiles = try await socialService.fetchUserInfo()
            print("유저 프로필 \(userProfiles)")
        } catch {
            self.error = DBError.firebaseError(error)
            print("Error fetching user profiles: \(error)")
        }
    }
    
    func addFavorite(userID: String) async {
        do {
            try await socialService.addFavoriteUser(userID: userID)
            print("User \(userID) added to favorites.")
        } catch let dbError as DBError {
            self.error = dbError
        } catch {
            self.error = DBError.firebaseError(error)
        }
    }
    
    func deleteFavorite(userID: String) async {
        do {
            try await self.socialService.deleteFavoriteUser(userID: userID)
            print("User \(userID) removed from favorites.")
        } catch {
            self.error = DBError.firebaseError(error)
        }
    }
}
