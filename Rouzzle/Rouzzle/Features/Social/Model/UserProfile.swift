//
//  UserProfile.swift
//  Rouzzle
//
//  Created by 김정원 on 11/15/24.
//

import Foundation
import FirebaseFirestore

struct UserProfile: Codable, Hashable {
    @DocumentID var documentId: String? // Firestore 문서 ID
    var nickname: String
    var profileImageUrl: String?
    var introduction: String?
    var isFavoriteUser: [String]?
    var routines: [Routine] = [] // 초기값으로 빈 배열 설정

    enum CodingKeys: String, CodingKey {
        case documentId
        case nickname = "name"
        case profileImageUrl = "profileUrlString"
        case introduction
        case isFavoriteUser
    }
}
