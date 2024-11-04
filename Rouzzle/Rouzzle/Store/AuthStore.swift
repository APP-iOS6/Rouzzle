//
//  AuthStore.swift
//  Rouzzle
//
//  Created by 김동경 on 11/4/24.
//

import SwiftUI
import Observation
import FirebaseAuth
import Factory

@Observable
class AuthStore {
    
    @ObservationIgnored
    @Injected(\.authService) private var authService
    
    @ObservationIgnored
    @AppStorage("authState") private var isLoggedIn: Bool = false
    
    enum AuthState {
        case splash
        case login
        case signup
        case authenticated
    }
    
    var authState: AuthState = .splash
    
    ///  자동 로그인 함수
    func autoLogin() {
        // isLoggedIn이 false라면 함수 실행을 멈춤
        guard isLoggedIn else {
            authState = .login
            return
        }
        
        print("자동 로그인 함수 불림")
        performLogin()
    }
    
    /// 로그인 함수
    func login() {
        let userUid = Auth.auth().currentUser?.uid ?? Utils.getDeviceUUID()
        
        Task {
            switch await authService.checkFirstUser(userUid) {
            case let .success(first):
                if first {
                    // 예전에 사용한 기록이 있던 유저이므로 홈화면으로
                    performLogin()
                } else {
                    // 처음인 유저이기 때문에 회원가입 절차 로직으로
                    authState = .signup
                }
            case let .failure(error):
                // 이미 예전에 로그인 했던 유저인지 확인 도중 에러가 발생했을 경우(ex 네트워크 오류) 토스트 메시지 띄어줘야 할 듯
                print(error.localizedDescription)
            }
        }
    }
    
    /// 로그인 시키는 함수
    func performLogin() {
        // 로그인 성공 시 isLoggedIn을 true로 설정
        isLoggedIn = true
        authState = .authenticated
    }
    
    func logOut() {
        do {
            isLoggedIn = false
            try Auth.auth().signOut()
            authState = .login
        } catch {
            authState = .login
        }
    }
    
}
