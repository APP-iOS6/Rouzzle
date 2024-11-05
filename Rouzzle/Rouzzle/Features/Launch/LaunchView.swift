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
                Text("ROUZZLE")
                    .font(.haloDek48)
                    .tracking(12)
                    .foregroundStyle(.button)
                    .transition(.opacity)
            case .login:
                LoginView()
                    .transition(.opacity)
            case .signup:
                SignUpView()
                    .transition(.opacity)
            case .authenticated:
                Text("로그인 됨")
                Button {
                    authStore.logOut()
                } label: {
                    Text("로그아웃")
                }
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
