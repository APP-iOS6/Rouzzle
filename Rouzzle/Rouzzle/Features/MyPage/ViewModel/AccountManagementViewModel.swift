//
//  AccountManagementViewModel.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/15/24.
//

import Foundation
import FirebaseAuth
import Observation

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
}
