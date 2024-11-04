//
//  LoginView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/2/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @Environment(AuthStore.self) private var authStore
    private let viewModel: LoginViewModel = LoginViewModel()
    var body: some View {
        VStack(alignment: .center, spacing: 17) {
            
            Spacer()
            
            Image(.loginlogo)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: 30)
                .padding(.horizontal, 64)
            
            Spacer()
            
            // MARK: 카카오 로그인 버튼
            Button {
                viewModel.send(.kakao)
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.kakaocolor)
                        .frame(maxWidth: .infinity, maxHeight: 60)
                    HStack {
                        Image(.kakaologo)
                            .padding(.trailing)
                        Text("카카오로 시작하기")
                            .foregroundStyle(.black)
                            .bold()
                    }
                }
            }
            .padding(.horizontal)
            
            // MARK: 애플 로그인 버튼
            HStack {
                Image(.applelogo)
                    .padding(.trailing)
                Text("Apple로 계속하기")
                    .bold()
            }
            .overlay {
                SignInWithAppleButton(.continue) { request in
                    viewModel.send(.appleLogin(request))
                } onCompletion: { result in
                    viewModel.send(.appleLoginCompletion(result))
                }
                .blendMode(.overlay)
            }
            .modifier(SignUpButtonModifier())
            
            // MARK: 구글 로그인 버튼
            Button {
                viewModel.send(.google)
            } label: {
                HStack {
                    Image(.googlelogo)
                        .padding(.trailing)
                    Text("Google로 계속하기")
                        .foregroundStyle(.black)
                        .bold()
                }
            }
            .modifier(SignUpButtonModifier())
            .padding(.bottom, 32)
        }
        .overlay {
            if viewModel.loadState == .loading {
                ProgressView()
            }
        }
        .onChange(of: viewModel.loadState) { _, newValue in
            if newValue == .completed {
                authStore.login()
            }
        }
        .padding()
    }
}

#Preview {
    LoginView()
        .environment(AuthStore())
}
