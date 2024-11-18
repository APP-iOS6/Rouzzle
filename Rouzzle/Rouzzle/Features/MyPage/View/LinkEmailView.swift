//
//  LinkEmailView.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/18/24.
//

import SwiftUI
import AuthenticationServices
import RiveRuntime

struct LinkEmailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthStore.self) private var authStore
    @State private var viewModel = LinkEmailViewModel()
    let action: () -> Void

    private let riveAnimation = RiveViewModel(fileName: "RouzzleLogin", stateMachineName: "State Machine 1")
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("subbackgroundcolor")
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .center, spacing: 17) {
                    
                    // MARK: 닫기 버튼
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.bold30)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 20)
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    // Rive 애니메이션
                    riveAnimation.view()
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
                        .padding(.bottom, 32)
                    
                    // MARK: 카카오 로그인 버튼
                    Button {
                        Task {
                            await viewModel.kakaoLinkAction { dismiss() }
                            action()
                        }
                        action()
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
                            let nonce = randomNonceString()
                            viewModel.currentNonce = nonce
                            request.requestedScopes = [.fullName, .email]
                            request.nonce = sha256(nonce)
                        } onCompletion: { result in
                            switch result {
                            case .success(let authorization):
                                let nonce = viewModel.currentNonce ?? ""
                                Task {
                                    await viewModel.appleLinkAction(
                                        authorization: authorization,
                                        nonce: nonce,
                                        dismiss: { dismiss() }
                                    )
                                    action()
                                }
                            case .failure(let error):
                                print("⛔️ 애플 로그인 실패: \(error.localizedDescription)")
                            }
                        }
                        .blendMode(.overlay)
                    }
                    .modifier(SignUpButtonModifier())
                    
                    // MARK: 구글 로그인 버튼
                    Button {
                        Task {
                            await viewModel.googleLinkAction {
                                dismiss()
                            }
                            action()
                        }
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
                    
                    Spacer()
                }
                .padding()
                .frame(width: geometry.size.width)
            }
        }
    }
}

#Preview {
    LinkEmailView(action: {})
}
