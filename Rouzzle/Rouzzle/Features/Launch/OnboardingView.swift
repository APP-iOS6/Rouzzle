//
//  OnboardingView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/6/24.
//

import SwiftUI
import RiveRuntime

struct OnboardingView: View {
   @Environment(AuthStore.self) var authStore
   @State private var showView = false
   @State private var hideWholeView = false
   
   private let riveAnimation = RiveViewModel(fileName: "RouzzleOnboarding", stateMachineName: "State Machine 1")
   
   var body: some View {
       ZStack {
           Color("OnBoardingBackgroundColor")
               .edgesIgnoringSafeArea(.all)
           
           GeometryReader { geometry in
               let size = geometry.size
               
               VStack {
                   riveAnimation.view()
                       .frame(width: size.width, height: size.height * 0.75)
                       .offset(y: showView ? -10 : -size.height / 2)
                       .opacity(showView ? 1 : 0)
                       .onAppear(perform: {
                           withAnimation(.spring(
                               response: 2,
                               dampingFraction: 0.8,
                               blendDuration: 0
                           ).delay(0.1)) {
                               showView = true
                           }
                       })
                   
                   Spacer()
                   
                   Button(
                       action: {
                           hideWholeView = true
                           DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                               authStore.authState = .login
                           }
                       },
                       label: {
                           Text("시작하기")
                               .font(.bold20)
                               .foregroundColor(.white)
                               .frame(width: 370, height: 46)
                               .background(Capsule().fill(Color.accentColor))
                       }
                   )
                   .padding(.bottom, 40)
                   .opacity(hideWholeView ? 0 : 1)
                   .animation(.easeOut(duration: 0.5), value: hideWholeView)
               }
               .frame(maxHeight: .infinity, alignment: .top)
               .padding(.top, size.height * 0.05)
               .offset(y: hideWholeView ? size.height : 0)
               .animation(.spring(response: 2, dampingFraction: 0.2), value: hideWholeView)
           }
       }
   }
}

#Preview {
    OnboardingView()
}
