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
            case .login:
                EmptyView()
            case .signup:
                EmptyView()
            case .authenticated:
                EmptyView()
            }
        }
        .animation(.smooth, value: authStore.authState)
    }
}

#Preview {
    LaunchView()
        .environment(AuthStore())
}
