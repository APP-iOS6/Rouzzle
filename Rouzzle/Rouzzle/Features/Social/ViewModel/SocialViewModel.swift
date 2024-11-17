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
    var userProfiles = Set<UserProfile>()
    var userFavorites: Set<UserProfile> {
        let favoriteIDs = userProfiles
            .first(where: { $0.documentId == Auth.auth().currentUser?.uid ?? Utils.getDeviceUUID() })?
            .isFavoriteUser ?? []
        
        let favoriteProfiles = userProfiles.filter { profile in
            favoriteIDs.contains(profile.documentId ?? "")
        }
        return favoriteProfiles
    }
    var error: DBError?
    var isSelectedUserUUIDs = Set<String>()
    
    init() {
        Task {
            await fetchUserProfiles()
        }
    }
    
    @MainActor
    func fetchUserProfiles() async {
        do {
            self.userProfiles = try await Set(socialService.fetchUserInfo())
            print("유저 프로필 \(userProfiles)")
        } catch {
            self.error = DBError.firebaseError(error)
            print("Error fetching user profiles: \(error)")
        }
    }
    
    func addFavoriteUsers() async {
        for userID in isSelectedUserUUIDs {
            do {
                try await socialService.addFavoriteUser(userID: userID)
                print("User \(userID) added to favorites.")
            } catch let dbError as DBError {
                self.error = dbError
            } catch {
                self.error = DBError.firebaseError(error)
            }
        }
        self.isSelectedUserUUIDs.removeAll()
    }
    
    @MainActor
    func deleteFavorite(userID: String) async {
        do {
            try await self.socialService.deleteFavoriteUser(userID: userID)
            print("User \(userID) removed from favorites.")
        } catch {
            self.error = DBError.firebaseError(error)
        }
    }
    
    func setSelectedUser(userID: String) {
        if isSelectedUserUUIDs.contains(userID) {
            self.isSelectedUserUUIDs.remove(userID)
        } else {
            self.isSelectedUserUUIDs.insert(userID)
        }
    }
    
    func judgeFavoriteUsers(userID: String) -> Bool {
        return !userFavorites.filter { $0.documentId == userID }.isEmpty
    }
}
