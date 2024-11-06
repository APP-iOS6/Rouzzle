//
//  LoginView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/2/24.
//

import SwiftUI
import RiveRuntime
import AuthenticationServices

struct LoginView: View {
    @Environment(AuthStore.self) private var authStore
    private let viewModel: LoginViewModel = LoginViewModel()
    
    // Rive 애니메이션 추가
    private let riveAnimation = RiveViewModel(fileName: "RouzzleSplash", stateMachineName: "State Machine 1")
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("OnBoardingBackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .center, spacing: 17) {
                    
                    Spacer()
                    
                    riveAnimation.view()
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
                        .padding(.bottom, 32)
                    
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
                    
                    Button {
                        authStore.login()
                    } label: {
                        Text("로그인 없이 시작하기")
                            .foregroundStyle(.gray)
                            .underline()
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 32)
                }
                .padding()
                .frame(width: geometry.size.width)
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
        }
    }
}

#Preview {
    LoginView()
        .environment(AuthStore())
}
