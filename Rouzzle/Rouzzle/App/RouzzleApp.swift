//
//  RouzzleApp.swift
//  Rouzzle
//
//  Created by 김정원 on 11/1/24.
//

import SwiftUI
import FirebaseCore
import KakaoSDKCommon
import KakaoSDKAuth
import SwiftData

@main
struct RouzzleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    // authStore = 로그인 상태를 전역적으로 관리하기 위해 @main에서 인스턴스 생성 후 enviroment로 관리
    private let authStore: AuthStore = AuthStore()
    
    init() {
        let kakaoAppkey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: kakaoAppkey as? String ?? "")
        print("appKey: \(kakaoAppkey)")
    }
    
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environment(authStore)
                .environment(SocialViewModel())
                .modelContainer(for: [RoutineItem.self, TaskList.self])
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
#if DEBUG
        // 테스트를 위해 First Play 상태 초기화
        UserDefaults.standard.removeObject(forKey: "hasShownFirstPlayToast")
        print("Debug: First Play 상태가 초기화되었습니다.")
#endif
        return true
    }
    
    // 카카오 로그인 open url 받기 위해
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        return false
    }
    
    // SceneDelegate 뭘 쓸지 정해줘야 함
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        
        sceneConfiguration.delegateClass = AppSceneDelegate.self
        
        return sceneConfiguration
    }
}
