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
    // 비회원 여부를 판단하는 프로퍼티
    var isGuestUser: Bool {
        Auth.auth().currentUser == nil // Firebase Auth에 저장된 사용자가 없는 경우 비회원
    }
    
    // 현재 사용자의 이메일을 반환하는 프로퍼티
    var userEmail: String {
        Auth.auth().currentUser?.email ?? "알 수 없음"
    }
}
