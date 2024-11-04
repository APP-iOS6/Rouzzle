//
//  AuthService.swift
//  Rouzzle
//
//  Created by 김동경 on 11/3/24.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices

protocol AuthServiceType {
    func signInWithGoogle() async -> Result<String, Error>
    func signInWithKakao() async -> Result<String, Error>
    func signInWithApple(_ authorization: ASAuthorization, nonce: String) async -> Result<String, Error>
}

// MARK: 구글 로그인 구현
class AuthService: AuthServiceType {
    @MainActor
    func signInWithGoogle() async -> Result<String, Error> {
        
        guard let clientId = FirebaseApp.app()?.options.clientID else {
            return (.failure(AuthError.clientIdError))
        }
        
        let config = GIDConfiguration(clientID: clientId)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            return .failure(AuthError.invalidate)
        }
        
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = userAuthentication.user
            
            guard let idToken = user.idToken?.tokenString else {
                return .failure(AuthError.tokenError)
            }
            
            // accessToken 생성
            let accessToken = user.accessToken.tokenString
            
            // creential 생성
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            return try await authenticationUserWithFirebase(credential: credential)
        } catch {
            return .failure(AuthError.invalidate)
        }
    }
}

// MARK: 카카오 로그인 구현을 위한 extension
extension AuthService {
    @MainActor
    func signInWithKakao() async -> Result<String, Error> {
        if UserApi.isKakaoTalkLoginAvailable() {
            do {
                let oauthToken = try await loginWithKakaoTalkAsync()
                _ = try await loginWithEmailPermissionAsync()
                
                guard let idToken = oauthToken.idToken else {
                    return .failure(AuthError.tokenError)
                }
                
                let accessToken = oauthToken.accessToken
                
                let crendential = OAuthProvider.credential(providerID: .custom("oidc.oidc.kakao"), idToken: idToken, accessToken: accessToken)
                
                return try await authenticationUserWithFirebase(credential: crendential)
                
            } catch {
                return .failure(AuthError.clientIdError)
            }
        } else {
            do {
                let oauthToken = try await loginWithKakaoTalkAccountAsync()
                _ = try await loginWithEmailPermissionAsync()
                
                guard let idToken = oauthToken.idToken else {
                    return .failure(AuthError.tokenError)
                }
                
                let accessToken = oauthToken.accessToken
                
                let credential = OAuthProvider.credential(providerID: .custom("oidc.oidc.kakao"), idToken: idToken, rawNonce: randomNonceString(), accessToken: accessToken)

                return try await authenticationUserWithFirebase(credential: credential)
                
            } catch {
                print(error.localizedDescription)
                return .failure(AuthError.clientIdError)
            }
        }
    }
    
    @MainActor
    private func loginWithKakaoTalkAsync() async throws -> OAuthToken {
        // 비동기 코드가 아닌 것을 비동기로 실행할 수 있도록 하는 함수, 오류 반환 가능
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error {
                    print(error.localizedDescription)
                    continuation.resume(throwing: error)
                }
                
                if let oauthToken {
                    continuation.resume(returning: oauthToken)
                }
            }
        }
    }
    
    @MainActor
    private func loginWithKakaoTalkAccountAsync() async throws -> OAuthToken {
        // 비동기 코드가 아닌 것을 비동기로 실행할 수 있도록 하는 함수, 오류 반환 가능
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error {
                    continuation.resume(throwing: error)
                }
                
                if let oauthToken {
                    continuation.resume(returning: oauthToken)
                }
            }
        }
    }
    
    @MainActor
    private func loginWithEmailPermissionAsync() async throws -> OAuthToken {
        try await withCheckedThrowingContinuation { continuation in
            let scopes: [String] = ["openid", "account_email"]
            
            UserApi.shared.loginWithKakaoAccount(scopes: scopes) { oauthToken, error in
                if let error {
                    continuation.resume(throwing: error)
                }
                
                if let oauthToken {
                    continuation.resume(returning: oauthToken)
                }
            }
        }
    }
}

extension AuthService {
    @MainActor
    func signInWithApple(_ authorization: ASAuthorization, nonce: String) async -> Result<String, Error> {
        guard let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return (.failure(AuthError.tokenError))
        }
        
        guard let appleIDToken = appleIdCredential.identityToken else {
            return (.failure(AuthError.tokenError))
        }
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            return (.failure(AuthError.tokenError))
        }
        
        let credential = OAuthProvider.credential(providerID: .apple, idToken: idTokenString, rawNonce: nonce)
        
        do {
            return try await authenticationUserWithFirebase(credential: credential)
        } catch {
            return .failure(AuthError.invalidate)
        }
    }
}

// MARK: 소셜 로그인으로 부처 credential을 받아 FirebaseAuth 로그인 하는 Extension
extension AuthService {
    private func authenticationUserWithFirebase(credential: AuthCredential) async throws -> Result<String, Error> {
        do {
            let result = try await Auth.auth().signIn(with: credential)
            return .success(result.user.uid)
        } catch {
            print("여기서 오류남")
            throw AuthError.signInError
        }
    }
}
