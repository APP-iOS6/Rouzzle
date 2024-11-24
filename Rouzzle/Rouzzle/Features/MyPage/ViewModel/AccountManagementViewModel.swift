//
//  AccountManagementViewModel.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/15/24.
//

import Foundation
import FirebaseAuth
import Observation
import SwiftData
import FirebaseFirestore

@Observable
class AccountManagementViewModel {
    var isGuestUser: Bool = true
    
    var userEmail: String = "알 수 없음"

    init() {
        updateUserStatus()
    }
    
    /// 사용자 상태 업데이트
    func updateUserStatus() {
        guard let currentUser = Auth.auth().currentUser else { return }
        isGuestUser = currentUser.isAnonymous
        userEmail = currentUser.isAnonymous ? "연동된 이메일 없음" : currentUser.email!
        print("✅ 업데이트된 유저 상태: \(isGuestUser), \(userEmail)")
    }
    
    /// SwiftData 루틴 초기화
    func deleteSwiftDataRoutines(context: ModelContext) {
        guard let user = Auth.auth().currentUser else { return }
        Task {
            do {
                try SwiftDataService.deleteAllRoutines(for: user.uid, context: context)
                print("✅ 루틴 초기화 성공")
            } catch {
                print("❌ 루틴 초기화 실패: \(error.localizedDescription)")
            }
        }
    }
    
    /// Firestore에서 특정 유저의 모든 루틴과 루틴 관련 데이터를 삭제
    func deleteFireStoreRoutines() async throws {
        let firestore = Firestore.firestore()
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        let userId = currentUser.uid
        
        // Routine 컬렉션 삭제
        try await deleteCollection(
            from: firestore.collection("Routine").whereField("userId", isEqualTo: userId),
            collectionName: "Routine"
        )
        
        // RoutineCompletion 컬렉션 삭제
        try await deleteCollection(
            from: firestore.collection("RoutineCompletion").whereField("userId", isEqualTo: userId),
            collectionName: "RoutineCompletion"
        )
    }

    // Firestore에서 특정 쿼리로 반환된 문서들을 일괄 삭제
    private func deleteCollection(from query: Query, collectionName: String) async throws {
        let documents = try await query.getDocuments().documents
        
        for document in documents {
            try await document.reference.delete()
            print("\(collectionName) Document successfully deleted with ID: \(document.documentID)")
        }
        
        print("✅ All documents in \(collectionName) for the query have been deleted.")
    }
}
