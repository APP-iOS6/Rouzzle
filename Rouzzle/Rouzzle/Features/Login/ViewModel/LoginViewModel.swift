//
//  LoginViewModel.swift
//  Rouzzle
//
//  Created by 김정원 on 11/2/24.
//
import Foundation
import Observation
import Factory
import AuthenticationServices

@Observable
class LoginViewModel {
    
    @ObservationIgnored
    @Injected(\.authService) private var authService
    
    @ObservationIgnored
    private var currentNonce: String?
    var loadState: LoadState = .none
    
    enum Action {
        case google
        case kakao
        case appleLogin(ASAuthorizationAppleIDRequest)
        case appleLoginCompletion(Result<ASAuthorization, Error>)
    }

    @MainActor
    func send(_ action: Action) {
        self.loadState = .loading
        switch action {
        case .google:
            googleLogin()
        case .kakao:
            kakaoLogin()
        case let .appleLogin(request):
            let nonce = randomNonceString()
            currentNonce = nonce
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)
        case let .appleLoginCompletion(result):
            switch result {
            case let .success(authorization):
                guard let nonce = currentNonce else {
                    self.loadState = .none
                    return
                }
                appleLogin(authorization, nonce: nonce)
            case .failure(_):
                self.loadState = .none
                print("애플 로그인 실패함")
            }
        }
    }
    
    @MainActor
    func googleLogin() {
        Task {
            switch await authService.signInWithGoogle() {
            case let .success(uid):
                self.loadState = .completed
                print(uid)
            case let .failure(error):
                self.loadState = .failed
                print(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    func kakaoLogin() {
        Task {
            switch await authService.signInWithKakao() {
            case let .success(uid):
                self.loadState = .completed
                print(uid)
            case let .failure(error):
                self.loadState = .failed
                print(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    func appleLogin(_ authorization: ASAuthorization, nonce: String) {
        Task {
            switch await authService.signInWithApple(authorization, nonce: nonce) {
            case let .success(uid):
                self.loadState = .completed
                print(uid)
            case let .failure(error):
                self.loadState = .failed
                print(error.localizedDescription)
            }
        }
    }
}
