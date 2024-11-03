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
            return .success("")
        } catch {
            return .failure(error)
        }
    }
}

