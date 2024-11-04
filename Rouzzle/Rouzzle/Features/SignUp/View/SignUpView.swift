//
//  SignUpView.swift
//  Rouzzle
//
//  Created by 김동경 on 11/5/24.
//

import SwiftUI

struct SignUpView: View {
    
    @Environment(AuthStore.self) private var authStore
    private let viewModel: SignUpViewModel = SignUpViewModel()
    
    var body: some View {
        
        @Bindable var vm = viewModel
        
        VStack {
            Text("ROUZZLE")
                .font(.haloDek48)
                .tracking(12)
                .foregroundStyle(.button)
                .transition(.opacity)
                .padding(.bottom, 64)
            
            Text("닉네임")
                .frame(maxWidth: .infinity, alignment: .leading)
                .bold()
                .padding([.top, .horizontal])
            
            TextField("똑똑한 컴퓨터", text: $vm.user.name)
                .modifier(StrokeTextFieldModifier())
                .padding()
            
            RouzzleButton(buttonType: .start) {
                Task {
                    await viewModel.uploadUserData()
                }
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
