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
    
    enum Action {
        case google
        case kakao
        case appleLogin(ASAuthorizationAppleIDRequest)
        case appleLoginCompletion(Result<ASAuthorization, Error>)
    }
    
    func action(_ action: Action) {
        switch action {
        case .google:
            return
        case .kakao:
            return
        case .appleLogin(_):
            return
        case .appleLoginCompletion(_):
            return
        }
    }
}
