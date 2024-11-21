//
//  AchievementView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/20/24.
//

import SwiftUI
import RiveRuntime

struct AchievementView: View {
    let message: String
    let riveViewModel: RiveViewModel
    @Binding var isShowing: Bool
    var duration: Double = 5.0
    
    var body: some View {
        VStack {
            if isShowing {
                Spacer()
                HStack(spacing: 20) {
                    riveViewModel.view()
                        .frame(width: 74, height: 74)
                    
                    Text(message)
                        .font(.semibold16)
                }
                .padding(.leading, 10)
                .padding(.trailing, 25)
                .padding(.vertical)
                .frame(width: 300, height: 100)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.subbackgroundcolor)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.themeColor, lineWidth: 2)
                        )
                        .shadow(color: .white, radius: 5)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        withAnimation {
                            isShowing = false
                        }
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
