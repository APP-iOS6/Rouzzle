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

protocol AuthServiceType {
    func signInWithGoogle() async -> Result<String, Error>
}

class AuthService: AuthServiceType {
    func signInWithGoogle() async -> Result<String, Error> {
        
        guard let clientId = FirebaseApp.app()?.options.clientID else {
            return (.failure(AuthError.clientIdError))
        }
        
        let config = GIDConfiguration(clientID: clientId)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = await windowScene.windows.first,
              let rootViewController = await window.rootViewController else {
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

extension AuthService {
    private func authenticationUserWithFirebase(credential: AuthCredential) async throws -> Result<String, Error> {
        do {
            let result = try await Auth.auth().signIn(with: credential)
            return .success(result.user.uid)
        } catch {
            throw AuthError.signInError
        }
    }
}
