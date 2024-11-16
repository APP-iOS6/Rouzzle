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
                    print("🟨 Auth DEBUG: 카카오톡 로그인 에러 발생 \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
                
                if let oauthToken {
                    print("🟨 Auth DEBUG: 카카오톡 로그인 성공")
                    print("🟨 OAuthToken: \(oauthToken)")
                    print("🟨 ID Token: \(oauthToken.idToken ?? "nil")")
                    print("🟨 Access Token: \(oauthToken.accessToken)")
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
            print("🍎 Apple ID Credential이 없음")
            return (.failure(AuthError.tokenError))
        }
        
        guard let appleIDToken = appleIdCredential.identityToken else {
            print("🍎 Apple ID Token이 없음")
            return (.failure(AuthError.tokenError))
        }
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            return (.failure(AuthError.tokenError))
        }
        
        // Refresh Token 저장
        if let refreshToken = appleIdCredential.authorizationCode.flatMap({ String(data: $0, encoding: .utf8) }) {
            UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
            print("🍎 APPLE DEBUG: Refresh Token 저장 완료")
        } else {
            print("🍎 APPLE DEBUG: Refresh Token 저장 실패")
        }
        
        let credential = OAuthProvider.credential(providerID: .apple, idToken: idTokenString, rawNonce: nonce)
        
        // Firebase 인증 처리
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
            
            // Storage에 있는 프로필 이미지 삭제
            let storageRef = Storage.storage().reference().child("UserProfile/\(userId).jpg")
            
            do {
                try await storageRef.delete()
                print("Profile image successfully deleted for userId: \(userId)")
            } catch let error as NSError {
                if error.code == StorageErrorCode.objectNotFound.rawValue {
                    // 파일이 없는 경우 처리
                    print("Profile image not found for userId: \(userId), skipping delete.")
                } else {
                    // 다른 에러는 그대로 처리
                    print("Error deleting profile image: \(error.localizedDescription)")
                }
            }
            
            // 외부 플랫폼 계정 해제(카카오/애플/구글)
            if let providerId = user.providerData.first?.providerID {
                switch providerId {
                case "google.com":
                    try await unlinkGoogleAccount()
                case "apple.com":
                    try await unlinkAppleAccount()
                case "oidc.oidc.kakao":
                    try await unlinkKakaoAccount()
                default:
                    print("알 수 없는 Provider ID: \(providerId)")
                }
            }
            
            // Firebase Authentication에서 계정 삭제
            try await user.delete()
            
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    /// 구글 계정 탈퇴
    private func unlinkGoogleAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.signInError // 로그인된 유저가 없으면 에러 반환
        }

        // Firebase에서 구글 계정 탈퇴
        _ = try await user.unlink(fromProvider: "google.com")
        print("🟩 Auth DEBUG: 구글 계정 연결 해제 성공")
    }
    
    /// 카카오 계정 탈퇴
    private func unlinkKakaoAccount() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            UserApi.shared.unlink { error in
                if let error = error {
                    print("🟨 Auth DEBUG: 카카오톡 탈퇴 중 에러 발생 \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                } else {
                    print("🟨 Auth DEBUG: 카카오톡 탈퇴 성공")
                    continuation.resume(returning: ())
                }
            }
        }
    }
    
    /// 애플 계정 탈퇴
    private func unlinkAppleAccount() async throws {
        // UserDefaults에서 refreshToken 가져오기 (Apple 로그인 시 저장해야 함)
        guard let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") else {
            print("🍎 APPLE DEBUG: Refresh Token이 없습니다.")
            throw AuthError.tokenError
        }
        
        // Apple Revoke URL 구성
        guard let url = URL(string: "https://us-central1-speakyourmind-5001b.cloudfunctions.net/revokeToken?refresh_token=\(refreshToken)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            print("🍎 APPLE DEBUG: URL 생성 실패")
            throw AuthError.tokenError
        }
        
        // URLSession을 사용하여 Revoke 요청
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            // HTTP 상태 코드 확인
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("🍎 APPLE DEBUG: 애플 계정 Revoke 성공")
            } else {
                print("🍎 APPLE DEBUG: 애플 계정 Revoke 실패, 상태 코드: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                throw AuthError.invalidate
            }
            
            // Firebase Authentication에서 Apple 계정 탈퇴
            guard let user = Auth.auth().currentUser else {
                print("🍎 APPLE DEBUG: Firebase 사용자가 존재하지 않습니다.")
                throw AuthError.signInError
            }
            _ = try await user.unlink(fromProvider: "apple.com")
            print("🍎 APPLE DEBUG: Firebase에서 애플 계정 탈퇴 성공!!")
            
        } catch {
            print("🍎 APPLE DEBUG: Apple Revoke 요청 중 에러 발생 \(error.localizedDescription)")
            throw error
        }
    }
}
