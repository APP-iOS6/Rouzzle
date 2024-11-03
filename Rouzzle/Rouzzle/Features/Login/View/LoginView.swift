//
//  LoginView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/2/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    private let viewModel: LoginViewModel = LoginViewModel()
    var body: some View {
        VStack(alignment: .center, spacing: 17) {
            
            Spacer()
            
            // MARK: 카카오 로그인 버튼
            Button {
                
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
                    print(request)
                } onCompletion: { result in
                    print(result)
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
        }
        .padding(.horizontal)
        .padding(.vertical, 32)
    }
}

#Preview {
    LoginView()
}
