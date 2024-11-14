//
//  SocialViewModel.swift
//  Rouzzle
//
//  Created by 김정원 on 11/13/24.
//

import Foundation
import Observation
import Factory
import FirebaseFirestore

@Observable
class SocialViewModel {
    @ObservationIgnored
    @Injected(\.socialService) private var socialService
    var userProfiles: [UserProfile] = []
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
        } catch {
            self.error = DBError.firebaseError(error)
            print("Error fetching user profiles: \(error)")
        }
    }
}

struct UserProfile: Codable, Hashable {
    @DocumentID var documentId: String? // Firestore 문서 ID
    var nickname: String
    var profileImageUrl: String?
    var introduction: String?
    var routines: [Routine] = [] // 초기값으로 빈 배열 설정

    enum CodingKeys: String, CodingKey {
        case documentId
        case nickname = "name"
        case profileImageUrl = "profileUrlString"
        case introduction
    }
}
