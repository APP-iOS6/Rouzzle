//
//  SocialService.swift
//  Rouzzle
//
//  Created by 김정원 on 11/13/24.
//

import Foundation
import FirebaseFirestore

protocol SocialServiceType {
    
    func fetchUserInfo() async throws -> [UserProfile]

}

class SocialService: SocialServiceType {
    private let db = Firestore.firestore()
    
    func fetchUserInfo() async throws -> [UserProfile] {
        do {
            let userSnapshot = try await db.collection("User").getDocuments()
            let users = userSnapshot.documents.compactMap { document -> UserProfile? in
                do {
                    let userProfile = try document.data(as: UserProfile.self)
                    return userProfile
                } catch {
                    print("Error decoding UserProfile: \(error)")
                    return nil
                }
            }
            
            let routineSnapshot = try await db.collection("Routine").getDocuments()
            let routines = routineSnapshot.documents.compactMap { document -> Routine? in
                do {
                    return try document.data(as: Routine.self)
                } catch {
                    print("Error decoding Routine: \(error)")
                    return nil
                }
            }

            let routinesByUser = Dictionary(grouping: routines, by: { $0.userId })

            let completeUserProfiles = users.map { user -> UserProfile in
                var user = user
                if let userId = user.documentId, let userRoutines = routinesByUser[userId] {
                    user.routines = userRoutines
                }
                return user
            }
            
            print("Fetched user profiles: \(completeUserProfiles)")
            return completeUserProfiles
        } catch {
            throw DBError.firebaseError(error)
        }
    }
}
