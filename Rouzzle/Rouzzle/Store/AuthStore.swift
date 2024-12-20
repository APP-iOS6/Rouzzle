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
    var loadState: LoadState = .none
    
    ///  자동 로그인 함수
    func autoLogin() {
        // 먼저 splash 상태로 시작
        authState = .splash
        
        // 3초 후에 로그인 상태 체크
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // isLoggedIn이 false라면 login으로 이동
            guard self.isLoggedIn else {
                self.authState = .login
                return
            }
            
            print("자동 로그인 함수 불림")
            self.performLogin()
        }
    }
    
    /// 로그인 함수
    func login() {
        Task {
            if let currentUser = Auth.auth().currentUser {
                // 현재 사용자가 있는 경우 UID를 사용
                let userUid = currentUser.uid
                await checkAndNavigate(for: userUid)
            } else {
                do {
                    // 익명 사용자 생성
                    let authResult = try await Auth.auth().signInAnonymously()
                    let userUid = authResult.user.uid
                    print("✅ 익명 사용자 생성 성공: \(userUid)")
                    await checkAndNavigate(for: userUid)
                } catch {
                    print("⛔️ 익명 사용자 생성 실패: \(error.localizedDescription)")
                }
            }
        }
    }

    // Firestore 데이터 확인 및 화면 전환 처리
    private func checkAndNavigate(for userUid: String) async {
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
    
    /// 로그인 시키는 함수
    func performLogin() {
        // 로그인 성공 시 isLoggedIn을 true로 설정
        isLoggedIn = true
        authState = .authenticated
    }
    
    /// 로그아웃 함수
    func logOut() {
        do {
            isLoggedIn = false
            try Auth.auth().signOut()
            authState = .login
        } catch {
            authState = .login
        }
    }
    
    /// 계정 탈퇴 함수
    func deleteAccount() {
        Task {
            loadState = .loading
            
            let result = await authService.deleteAccount()
            switch result {
            case .success:
                isLoggedIn = false
                authState = .login
                loadState = .completed
            case .failure(let error):
                print("계정 삭제 중 오류 발생: \(error.localizedDescription)")
                loadState = .none
            }
        }
    }
}
