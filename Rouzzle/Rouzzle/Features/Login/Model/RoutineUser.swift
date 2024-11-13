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
    var profileUrlString = "https://firebasestorage.googleapis.com/v0/b/rouzzle-e4c69.firebasestorage.app/o/UserProfile%2FProfile.png?alt=media&token=94dc34d2-e7dd-4518-bd23-9c7866cfda2e"
    var introduction = ""
}
