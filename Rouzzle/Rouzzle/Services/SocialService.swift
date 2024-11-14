//
//  SocialService.swift
//  Rouzzle
//
//  Created by 김정원 on 11/13/24.
//

import Foundation
import FirebaseFirestore

protocol SocialServiceType {
    /// 모든 루틴을 사용자별로 그룹화 한다.
    func fetchRoutinesGroupedByUser() async throws -> [String: [Routine]]
        
    /// userId 로 닉네임 패치
    func fetchAllUserNicknames() async throws -> [String: String]
    
    func fetchUserProfileImage(userID: String) async throws -> String?
}

class SocialService: SocialServiceType {
    private let db = Firestore.firestore()

    func fetchAllUserNicknames() async throws -> [String: String] {
        do {
            let snapshot = try await db.collection("User").getDocuments()
            
            let idToNameMap = snapshot.documents.reduce(into: [String: String]()) { result, document in
                if let nickname = document.data()["name"] as? String {
                    result[document.documentID] = nickname
                } else {
                    print("Nickname field is missing for userID \(document.documentID)")
                }
            }
            
            print("Fetched user nicknames: \(idToNameMap)")
            return idToNameMap
        } catch {
            throw DBError.firebaseError(error)
        }
    }
    
    func fetchUserProfileImage(userID: String) async throws -> String? {
        do {
            let document = try await db.collection("User").document(userID).getDocument()
            
            if let imageStr = document.data()?["profileUrlString"] as? String {
                return imageStr
            } else {
                return nil
            }
        } catch {
            throw DBError.firebaseError(error)
        }
    }
    
    func fetchRoutinesGroupedByUser() async throws -> [String: [Routine]] {
        
        do {
            let snapshot = try await db.collection("Routine").getDocuments()
            let routines = try snapshot.documents.compactMap { try $0.data(as: Routine.self) }
            let groupedRoutines = Dictionary(grouping: routines, by: { $0.userId })
            return groupedRoutines
        } catch {
            throw DBError.firebaseError(error)
        }
    }
}
