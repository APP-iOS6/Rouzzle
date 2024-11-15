//
//  AuthService.swift
//  Rouzzle
//
//  Created by 김동경 on 11/3/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices
import FirebaseStorage

protocol AuthServiceType {
    func checkFirstUser(_ userUid: String) async -> Result<Bool, Error>
    func signInWithGoogle() async -> Result<String, Error>
    func signInWithKakao() async -> Result<String, Error>
    func signInWithApple(_ authorization: ASAuthorization, nonce: String) async -> Result<String, Error>
    func deleteAccount() async -> Result<Void, Error>
}

class AuthService: AuthServiceType {
    /// FireStore에 이미 userUid로 된 유저 데이터가 있는지 확인하는 함수
    func checkFirstUser(_ userUid: String) async -> Result<Bool, Error> {
        do {
            let result = try await Firestore.firestore().collection("User").document(userUid).getDocument().exists
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
}

// MARK: 구글 로그인 구현
extension AuthService {
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

// MARK: 애플 로그인 구현
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

// MARK: 계정 탈퇴(auth, storage에서 해당 유저 데이터 다 지우기)
extension AuthService {
    @MainActor
    func deleteAccount() async -> Result<Void, Error> {
        guard let user = Auth.auth().currentUser else {
            return .failure(AuthError.signInError) // 로그인된 유저가 없으면 에러 반환
        }
        
        let userId = user.uid
        let firestore = Firestore.firestore()
        
        do {
            // 재인증 수행
            try await reauthenticateUser(user)
            
            // Firestore User 컬렉션에서 유저 삭제
            try await firestore.collection("User").document(userId).delete()
            
            // Firestore Routine 컬렉션에서 해당 유저의 모든 루틴 삭제
            let routineQuerySnapshot = try await firestore.collection("Routine").whereField("userId", isEqualTo: userId).getDocuments()
            for document in routineQuerySnapshot.documents {
                try await document.reference.delete()
                print("Routine Document successfully deleted with userId: \(userId)")
            }

            // Firestore RoutineCompletion 컬렉션에서 해당 유저의 모든 루틴 컴플리션 삭제
            let routineCompletionQuerySnapshot = try await firestore.collection("RoutineCompletion").whereField("userId", isEqualTo: userId).getDocuments()
            for document in routineCompletionQuerySnapshot.documents {
                try await document.reference.delete()
                print("Routine Completion Document successfully deleted with userId: \(userId)")
            }
            
            // Storage에 있는 데이터 삭제
            let storageRef = Storage.storage().reference()
            
            let profileImageRef = storageRef.child("UserProfile/\(userId).jpg")
            
            do {
                try await profileImageRef.delete()
                print("Profile image successfully deleted for userId: \(userId)")
            } catch {
                print("Error deleting profile image: \(error)")
            }
            
            // Firebase Authentication에서 계정 삭제
            try await user.delete()
            
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: 사용자 재인증 함수
    @MainActor
    private func reauthenticateUser(_ user: FirebaseAuth.User) async throws {
        if let providerData = user.providerData.first {
            let providerId = providerData.providerID
            var credential: AuthCredential
            
            switch providerId {
            case GoogleAuthProviderID:
                // 구글 로그인 재인증
                guard let clientId = FirebaseApp.app()?.options.clientID else {
                    throw AuthError.clientIdError
                }
                
                let config = GIDConfiguration(clientID: clientId)
                GIDSignIn.sharedInstance.configuration = config
                
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let rootViewController = windowScene.keyWindow?.rootViewController else {
                    throw AuthError.invalidate
                }
                
                let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
                let idToken = result.user.idToken?.tokenString ?? ""
                let accessToken = result.user.accessToken.tokenString
                credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
                
            // 카카오 로그인 재인증
                
            // 애플 로그인 재인증
                
            default:
                throw AuthError.reauthenticationError
            }
            
            // 재인증 수행
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                user.reauthenticate(with: credential) { _, error in
                    if let error = error {
                        continuation.resume(throwing: error) // 오류 발생 시 throw
                    } else {
                        continuation.resume(returning: ()) // 성공 시 빈 결과 반환
                    }
                }
            }
        } else {
            throw AuthError.reauthenticationError
        }
    }
}
