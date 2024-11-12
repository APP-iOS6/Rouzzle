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
    
    private let riveAnimation = RiveViewModel(fileName: "RouzzleOnboarding", stateMachineName: "State Machine 1")
    
    var body: some View {
        @Bindable var vm = viewModel
        
        ZStack {
            Color("OnBoardingBackgroundColor")
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
                        Text("닉네임")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                        
                        TextField("똑똑한 컴퓨터", text: $vm.user.name)
                            .modifier(StrokeTextFieldModifier())
                        
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
