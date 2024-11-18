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
    func signInWithGoogle(shouldLink: Bool) async -> Result<String, Error>
    func signInWithKakao(shouldLink: Bool) async -> Result<String, Error>
    func signInWithApple(_ authorization: ASAuthorization, nonce: String, shouldLink: Bool) async -> Result<String, Error>
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
    func signInWithGoogle(shouldLink: Bool = false) async -> Result<String, Error> {
        
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
            
            if shouldLink {
                // 이메일 연동을 위한 토큰으로 linkWithSocial 호출
                return await linkWithSocial(provider: .google(idToken: idToken, accessToken: accessToken))
            } else {
                // 기존 로그인 흐름 유지
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
                return try await authenticationUserWithFirebase(credential: credential)
            }
        } catch {
            return .failure(AuthError.invalidate)
        }
    }
}

// MARK: 카카오 로그인 구현을 위한 extension
extension AuthService {
    @MainActor
    func signInWithKakao(shouldLink: Bool = false) async -> Result<String, Error> {
        do {
            let oauthToken: OAuthToken
            if UserApi.isKakaoTalkLoginAvailable() {
                oauthToken = try await loginWithKakaoTalkAsync()
            } else {
                oauthToken = try await loginWithKakaoTalkAccountAsync()
            }
            
            _ = try await loginWithEmailPermissionAsync()
            
            guard let idToken = oauthToken.idToken else {
                return .failure(AuthError.tokenError)
            }
            let accessToken = oauthToken.accessToken
            
            if shouldLink {
                print("🔗 카카오 계정을 익명 사용자와 연동합니다.")
                // 이메일 연동을 위한 토큰으로 linkWithSocial 호출
                return await linkWithSocial(provider: .kakao(idToken: idToken, accessToken: accessToken))
            } else {
                print("🔑 카카오 계정으로 로그인합니다.")
                // 기존 로그인 흐름 유지
                let credential = OAuthProvider.credential(providerID: .custom("oidc.oidc.kakao"), idToken: idToken, accessToken: accessToken)
                return try await authenticationUserWithFirebase(credential: credential)
            }
        } catch {
            print("⛔️ 카카오 로그인 실패: \(error.localizedDescription)")
            return .failure(AuthError.clientIdError)
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
    func signInWithApple(_ authorization: ASAuthorization, nonce: String, shouldLink: Bool = false) async -> Result<String, Error> {
        guard let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return (.failure(AuthError.tokenError))
        }
        
        guard let appleIDToken = appleIdCredential.identityToken else {
            return (.failure(AuthError.tokenError))
        }
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            return (.failure(AuthError.tokenError))
        }

        if shouldLink {
            // 이메일 연동을 위한 토큰으로 linkWithSocial 호출
            return await linkWithSocial(provider: .apple(idToken: idTokenString, nonce: nonce))
        } else {
            // 기존 로그인 흐름 유지
            let credential = OAuthProvider.credential(providerID: .apple, idToken: idTokenString, rawNonce: nonce)
            do {
                return try await authenticationUserWithFirebase(credential: credential)
            } catch {
                return .failure(AuthError.invalidate)
            }
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

// MARK: 계정 탈퇴
extension AuthService {
    @MainActor
    func deleteAccount() async -> Result<Void, Error> {
        guard let user = Auth.auth().currentUser else {
            return .failure(AuthError.signInError) // 로그인된 유저가 없으면 에러 반환
        }
        
        let userId = user.uid
        
        do {
            try await deleteFirestoreData(for: userId)
            try await deleteStorageData(for: userId)
              
            // 카카오/애플/구글 계정 탈퇴
            if let providerId = user.providerData.first?.providerID {
                switch providerId {
                case "google.com":
                    try await removeGoogleAccount()
                case "apple.com":
                    try await removeAppleAccount()
                case "oidc.oidc.kakao":
                    try await removeKakaoAccount()
                default:
                    print("알 수 없는 Provider ID: \(providerId)")
                }
            }
            
            // Firebase Authentication에서 계정 삭제
            try await user.delete()
            print("🟩 Firebase Auth 계정 삭제 성공")
            
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    // 구글 계정 탈퇴
    private func removeGoogleAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.signInError
        }

        do {
            _ = try await user.unlink(fromProvider: "google.com")
            print("🟩 Auth DEBUG: 구글 계정 탈퇴 성공!!")
        } catch let error {
            print("🟩 Auth DEBUG: 구글 계정 탈퇴 중 에러 발생 \(error.localizedDescription)")
            throw error
        }
    }
    
    // 카카오 계정 탈퇴
    private func removeKakaoAccount() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            UserApi.shared.unlink { error in
                if let error = error {
                    print("🟨 Auth DEBUG: 카카오톡 탈퇴 중 에러 발생 \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                } else {
                    print("🟨 Auth DEBUG: 카카오톡 탈퇴 성공!!")
                    continuation.resume(returning: ())
                }
            }
        }
    }
    
    // 애플 계정 탈퇴
    private func removeAppleAccount() async throws {
        let token = UserDefaults.standard.string(forKey: "refreshToken")
        
        if let token = token {
            let url = URL(string: "https://us-central1-speakyourmind-5001b.cloudfunctions.net/revokeToken?refresh_token=\(token)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "https://apple.com")!
            let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
                guard data != nil else { return }
                print("🍎 APPLE DEBUG: 탈퇴 성공!!")
            }
            task.resume()
        }
    }
}

// MARK: 데이터 삭제(Firestore, Storage)
extension AuthService {
    // Firestore 데이터 삭제
    private func deleteFirestoreData(for userId: String) async throws {
        let firestore = Firestore.firestore()
        
        // Firestore User 컬렉션에서 유저 삭제
        try await firestore.collection("User").document(userId).delete()
        print("Firestore User document successfully deleted for userId: \(userId)")
        
        // Firestore Routine 컬렉션에서 유저의 모든 루틴 삭제
        let routineQuerySnapshot = try await firestore.collection("Routine").whereField("userId", isEqualTo: userId).getDocuments()
        for document in routineQuerySnapshot.documents {
            try await document.reference.delete()
            print("Routine Document successfully deleted with userId: \(userId)")
        }
        
        // Firestore RoutineCompletion 컬렉션에서 유저의 모든 루틴 컴플리션 삭제
        let routineCompletionQuerySnapshot = try await firestore.collection("RoutineCompletion").whereField("userId", isEqualTo: userId).getDocuments()
        for document in routineCompletionQuerySnapshot.documents {
            try await document.reference.delete()
            print("Routine Completion Document successfully deleted with userId: \(userId)")
        }
    }
    
    // Storage 프로필 이미지 데이터 삭제
    private func deleteStorageData(for userId: String) async throws {
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
                throw error
            }
        }
    }
}

extension AuthService {
    /// 이메일 연동 함수
    @MainActor
    func linkWithSocial(provider: AuthProvider) async -> Result<String, Error> {
        guard let user = Auth.auth().currentUser else {
            return .failure(AuthError.signInError) // 여전히 nil이라면 실패 반환
        }
        
        do {
            let credential: AuthCredential
            switch provider {
            case .google(let idToken, let accessToken):
                credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            case .apple(let idToken, let nonce):
                credential = OAuthProvider.credential(providerID: .apple, idToken: idToken, rawNonce: nonce)
            case .kakao(let idToken, let accessToken):
                credential = OAuthProvider.credential(providerID: .custom("oidc.oidc.kakao"), idToken: idToken, accessToken: accessToken)
            }
            
            // 현재 사용자에 소셜 계정 연동
            let result = try await user.link(with: credential)
            let linkedUserId = result.user.uid
            print("✅ 이메일 연동 성공: \(user.uid)")
            return .success(linkedUserId)
        } catch {
            print("⛔️ 이메일 연동 실패: \(error.localizedDescription)")
            return .failure(error)
        }
    }
    
    enum AuthProvider {
        case google(idToken: String, accessToken: String)
        case apple(idToken: String, nonce: String)
        case kakao(idToken: String, accessToken: String)
    }
}
