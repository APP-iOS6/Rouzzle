//
//  MissingPuzzleView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/21/24.
//

import SwiftUI

struct MissingPuzzleView: View {
    let onRoutineButtonTap: () -> Void
    let onCloseButtonTap: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("사용 가능한 퍼즐이 없습니다. 😢")
                    .font(.medium16)
                    .multilineTextAlignment(.center)
                    .padding(.top, 48)
                    .padding(.bottom, 24)
                
                VStack(spacing: 8) {
                    Button(action: onRoutineButtonTap) {
                        Text("루틴 하러 가기")
                            .font(.semibold14)
                            .foregroundColor(.white)
                            .frame(width: 209, height: 44)
                            .background(Color.accent)
                            .clipShape(RoundedRectangle(cornerRadius: 9))
                    }
                    
                    Button(action: onCloseButtonTap) {
                        Text("닫기")
                            .font(.semibold14)
                            .foregroundColor(.accent)
                            .frame(width: 209, height: 44)
                            .overlay(
                                RoundedRectangle(cornerRadius: 9)
                                    .stroke(Color.accent, lineWidth: 1)
                            )
                    }
                }
                .padding(.bottom, 32)
            }
            .frame(width: 261, height: 228)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview("No Puzzle Alert") {
    ZStack {
        Color.white.ignoresSafeArea()
        MissingPuzzleView(
            onRoutineButtonTap: {
                print("루틴 하러 가기 버튼 탭")
            },
            onCloseButtonTap: {
                print("닫기 버튼 탭")
            }
        )
    }
}
