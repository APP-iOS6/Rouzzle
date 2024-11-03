//
//  AppSceneDelegate.swift
//  Rouzzle
//
//  Created by 김동경 on 11/4/24.
//

import UIKit
import KakaoSDKAuth

class AppSceneDelegate: UIResponder, UIWindowSceneDelegate {
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
}
