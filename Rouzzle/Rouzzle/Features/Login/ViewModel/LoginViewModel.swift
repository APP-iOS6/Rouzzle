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
            print(request)
            return
        case let .appleLoginCompletion(result):
            print(result)
            return
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
}
