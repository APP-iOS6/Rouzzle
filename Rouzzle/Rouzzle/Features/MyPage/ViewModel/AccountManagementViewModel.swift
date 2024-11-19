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

@Observable
class AccountManagementViewModel {
    var isGuestUser: Bool = true
    
    var userEmail: String = "알 수 없음"

    init() {
        updateUserStatus()
    }
    
    // 사용자 상태 업데이트
    func updateUserStatus() {
        guard let currentUser = Auth.auth().currentUser else { return }
        isGuestUser = currentUser.isAnonymous
        userEmail = currentUser.isAnonymous ? "연동된 이메일 없음" : currentUser.email!
        print("✅ 업데이트된 유저 상태: \(isGuestUser), \(userEmail)")
    }
    
    // SwiftData 루틴 초기화
    func deleteRoutines(context: ModelContext) {
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
}
