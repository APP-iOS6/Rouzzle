//
//  PuzzleGuideOverlay.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/19/24.
//

import SwiftUI

struct PuzzleGuideOverlay: View {
    @Binding var isShowingGuide: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea(edges: .all)
                .onTapGesture {
                    isShowingGuide = false
                }
            
            // 가이드 컨텐츠
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .center, spacing: 0) {
                    Text("루즐 챌린지 참여 안내")
                        .font(.bold14)
                        .underline()
                        .padding(.top, 24)
                    
                    // 본문
                    VStack(spacing: 24) {
                        VStack(spacing: 5) {
                            Text("퍼즐을 ") + Text("30일 이내에 완성").bold() + Text("하면,")
                            Text("🏵️특별한 배지가 수여됩니다!")
                        }
                        
                        VStack(spacing: 5) {
                            Text("단, ") + Text("30일 이내 퍼즐을 완성하지 못하면").bold() + Text(",")
                            Text("배지는 획득할 수 없어요...😢")
                        }
                        
                        Text("함께 건강한 습관을 만들어봐요! 💪🏻")
                    }
                    .font(.light14)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.top, 32)
                    .padding(.bottom, 24)
                }
                .frame(width: 320, height: 247)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Button {
                    isShowingGuide = false
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color.accent)
                        .padding(16)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.white.ignoresSafeArea()
        PuzzleGuideOverlay(isShowingGuide: .constant(true))
    }
}
