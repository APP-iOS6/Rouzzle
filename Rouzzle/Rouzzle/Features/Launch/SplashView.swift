//
//  SplashView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/5/24.
//

import SwiftUI
import RiveRuntime

struct SplashView: View {
    @State private var isActive = false
    private let riveAnimation = RiveViewModel(fileName: "RouzzleSplash", stateMachineName: "State Machine 1")
    
    var body: some View {
        if isActive {
//            OnboardingView()
        } else {
            ZStack {
                Color("OnBoardingBackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    // 애니메이션 뷰를 화면 중앙보다 위로 올리기 위해 offset 추가
                    riveAnimation.view()
                        .frame(width: 300, height: 300)
                        .offset(y: -50) // y 값을 음수로 설정하여 위로 이동
                  
                    Spacer()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}

