//
//  UserService.swift
//  Rouzzle
//
//  Created by 김동경 on 11/5/24.
//

import Foundation
import FirebaseFirestore

protocol UserServiceType {
    func uploadUserData(_ userUid: String, user: RoutineUser) async -> Result<Void, Error>
    func fetchUserData(_ userUid: String) async -> Result<RoutineUser, Error>
}

class UserService: UserServiceType {
    
    private let db = Firestore.firestore()
    
    /// 유저 데이터를 FireStore User컬렉션에 등록하는 함수
    func uploadUserData(_ userUid: String, user: RoutineUser) async -> Result<Void, Error> {
        do {
            let userEncodeData = try Firestore.Encoder().encode(user)
            try await self.db.collection("User").document(userUid).setData(userEncodeData, merge: true)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    /// FireStore User컬렉션에 등록된 유저 데이터를 불러오는 함수
    func fetchUserData(_ userUid: String) async -> Result<RoutineUser, Error> {
        do {
            let document = try await db.collection("User").document(userUid).getDocument()
            let user = try document.data(as: RoutineUser.self)
            return .success(user)
        } catch {
            return .failure(error)
        }
    }
}
