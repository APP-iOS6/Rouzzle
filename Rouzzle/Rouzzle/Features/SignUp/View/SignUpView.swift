//
//  SignUpView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/12/24.
//

import SwiftUI
import RiveRuntime

struct SignUpView: View {
    @Environment(AuthStore.self) private var authStore
    private let viewModel: SignUpViewModel = SignUpViewModel()
    
    @State private var showView = false
    @State private var hideWholeView = false
    @State private var showPopup = true
    @State private var showTermsOfService = false
    @State private var showPrivacyPolicy = false
    @State private var isPrivacyPolicyAccepted = false
    @State private var isTermsOfServiceAccepted = false
    
    private let riveAnimation = RiveViewModel(fileName: "RouzzleOnboarding", stateMachineName: "State Machine 1")
    
    var body: some View {
        @Bindable var vm = viewModel
        
        ZStack {
            Color("subbackgroundcolor")
                .edgesIgnoringSafeArea(.all)
            
            GeometryReader { geometry in
                let size = geometry.size
                
                VStack(alignment: .center, spacing: 0) {
                    Spacer()
                    
                    // Rive 애니메이션
                    riveAnimation.view()
                        .frame(width: size.width * 0.9, height: size.width * 0.9)
                        .offset(y: showView ? -20 : -size.height / 2)
                        .opacity(showView ? 1 : 0)
                        .onAppear {
                            withAnimation(.spring(
                                response: 2,
                                dampingFraction: 0.8,
                                blendDuration: 0
                            ).delay(0.1)) {
                                showView = true
                            }
                        }
                        .padding(.bottom, -20)
                    
                    // 닉네임 입력 필드
                    VStack(alignment: .leading, spacing: 16) {
                        Text("루즐러가 된 것을 축하드려요!")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.semibold20)
                        
                        TextField("닉네임을 입력해 주세요.", text: $vm.user.name)
                            .modifier(StrokeTextFieldModifier())
                            .font(.regular16)
                        
                        Spacer().frame(height: 18)
                        
                        RouzzleButton(buttonType: .start) {
                            Task {
                                await viewModel.uploadUserData()
                            }
                        }
                        .opacity(hideWholeView ? 0 : 1)
                        .animation(.easeOut(duration: 0.5), value: hideWholeView)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .offset(y: hideWholeView ? size.height : 0)
                .animation(.spring(response: 2, dampingFraction: 0.2), value: hideWholeView)
            }
            
            if showPopup {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(1)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("약관에 동의해 주세요.")
                        .font(.semibold24)
                    
                    Divider()
                    
                    HStack {
                        Button {
                            isPrivacyPolicyAccepted.toggle()
                        } label: {
                            Image(systemName: "checkmark")
                                .foregroundStyle(isPrivacyPolicyAccepted ? .accent : .graylight)
                                .bold()
                        }
                        
                        Button {
                            showPrivacyPolicy.toggle()
                        } label: {
                            HStack {
                                Text("개인정보 처리방침 동의(필수)")
                                    .font(.regular18)
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                            }
                        }
                    }
                   
                    HStack {
                        Button {
                            isTermsOfServiceAccepted.toggle()
                        } label: {
                            Image(systemName: "checkmark")
                                .foregroundStyle(isTermsOfServiceAccepted ? .accent : .graylight)
                                .bold()
                        }
                        
                        Button {
                            showTermsOfService.toggle()
                        } label: {
                            HStack {
                                Text("서비스 이용 약관 동의(필수)")
                                    .font(.regular18)
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                            }
                        }
                    }
                    .padding(.bottom)
                    
                    Button {
                        withAnimation {
                            showPopup = false
                        }
                    } label: {
                        Text("완료")
                            .font(.medium18)
                            .frame(maxWidth: .infinity, minHeight: 40)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isPrivacyPolicyAccepted == false || isTermsOfServiceAccepted == false)
                }
                .padding(30)
                .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
                .padding(.horizontal, 30)
                .zIndex(2)
            }
        }
        .sheet(isPresented: $showTermsOfService) {
            SafariView(url: URL(string: "https://overjoyed-garden-c10.notion.site/ae2c4d8c27044967ae9772294f58c428?pvs=74")!)
        }
        .sheet(isPresented: $showPrivacyPolicy) {
            SafariView(url: URL(string: "https://overjoyed-garden-c10.notion.site/1358843116e6463c805fda45dac76ce0?pvs=4")!)
        }
        .overlay {
            if viewModel.loadState == .loading {
                ProgressView()
            }
        }
        .onChange(of: viewModel.loadState) { _, newValue in
            if newValue == .completed {
                authStore.performLogin()
            }
        }
    }
}

#Preview {
    SignUpView()
        .environment(AuthStore())
}
