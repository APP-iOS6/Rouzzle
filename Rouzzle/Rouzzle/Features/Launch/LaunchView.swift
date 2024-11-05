//
//  LaunchView.swift
//  Rouzzle
//
//  Created by 김동경 on 11/4/24.
//

import SwiftUI

struct LaunchView: View {
    
    @Environment(AuthStore.self) var authStore
    
    var body: some View {
        VStack {
            switch authStore.authState {
            case .splash:
                SplashView()
                    .transition(.opacity)
            case .onboarding:
                OnboardingView()
                    .transition(.opacity)
            case .login:
                LoginView()
                    .transition(.opacity)
            case .signup:
                SignUpView()
                    .transition(.opacity)
            case .authenticated:
                ContentView()
                    .transition(.opacity)
            }
        }
        .animation(.smooth, value: authStore.authState)
        .onAppear {
            authStore.autoLogin()
        }
    }
}

#Preview {
    LaunchView()
        .environment(AuthStore())
}
