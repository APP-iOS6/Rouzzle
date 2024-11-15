//
//  SocialService.swift
//  Rouzzle
//
//  Created by 김정원 on 11/13/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol SocialServiceType {
    
    func fetchUserInfo() async throws -> [UserProfile]
    
    func addFavoriteUser(userID: String) async throws
    
    func deleteFavoriteUser(userID: String) async throws 

}

class SocialService: SocialServiceType {
    private let db = Firestore.firestore()
    
    func addFavoriteUser(userID: String) async throws {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            throw DBError.firebaseError(NSError(domain: "User Not Logged In", code: 401, userInfo: nil))
        }
        
        do {
            try await db.collection("User").document(currentUserID).updateData([
                "isFavoriteUser": FieldValue.arrayUnion([userID])
            ])
        } catch {
            throw DBError.firebaseError(error)
        }
    }
    
    func deleteFavoriteUser(userID: String) async throws {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            throw DBError.documenetIdError
        }
        
        let userDocumentRef = db.collection("User").document(currentUserID)
        
        do {
            let document = try await userDocumentRef.getDocument()
            guard var favorites = document.data()?["isFavoriteUser"] as? [String] else {
                throw DBError.serializationError
            }
            
            if let index = favorites.firstIndex(of: userID) {
                favorites.remove(at: index)
            } else {
                print("User ID \(userID) is not in the favorites list.")
                return
            }
            
            try await userDocumentRef.updateData(["isFavoriteUser": favorites])
            print("Successfully deleted user \(userID) from favorites.")
        } catch {
            throw DBError.firebaseError(error)
        }
    }
    
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
