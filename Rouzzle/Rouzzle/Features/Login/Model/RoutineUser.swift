//
//  RoutineUser.swift
//  Rouzzle
//
//  Created by 김정원 on 11/2/24.
//
import Foundation
import FirebaseFirestore

struct RoutineUser: Codable, Equatable {
    @DocumentID var id: String?
    var name: String
    var profileUrlString: String?
    var introduction = ""
}

struct AlgoliaUser: Codable {
    var id: String? // Algolia의 objectID를 매핑
    var name: String
    var profileUrlString: String?
    var introduction: String
    
    enum CodingKeys: String, CodingKey {
        case id = "objectID" // Algolia objectID와 매핑
        case name
        case profileUrlString
        case introduction
    }
}
