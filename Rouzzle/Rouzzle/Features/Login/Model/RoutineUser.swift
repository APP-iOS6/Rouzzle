//
//  RoutineUser.swift
//  Rouzzle
//
//  Created by 김정원 on 11/2/24.
//
import Foundation
import FirebaseFirestore

struct RoutineUser: Codable {
    @DocumentID var id: String?
    var name: String
    var profileUrlString: String?
    var introduction = ""
}
