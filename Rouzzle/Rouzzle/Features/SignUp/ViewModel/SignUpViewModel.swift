//
//  SignUpVIewModel.swift
//  Rouzzle
//
//  Created by 김동경 on 11/5/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Observation
import Factory

@Observable
class SignUpViewModel {
    
    @ObservationIgnored
    @Injected(\.userService) private var userService
    
    var loadState: LoadState = .none
    var user: RoutineUser = RoutineUser(name: "")
    var errorMessage: String? // 토스트 메시지 띄울 메시지 내용
    
    @MainActor
    func uploadUserData() async {
        
        guard !user.name.isEmpty else {
            errorMessage = "닉네임을 입력해 주세요."
            return
        }
        
        let userUid = Auth.auth().currentUser?.uid ?? Utils.getDeviceUUID()
        loadState = .loading
        
        switch await userService.uploadUserData(userUid, user: user) {
        case .success:
            // 회원가입 성공함
            loadState = .completed
        case .failure:
            // 회원가입 실패함(네트워크 오류 등)
            loadState = .failed
        }
        
    }
    
}
