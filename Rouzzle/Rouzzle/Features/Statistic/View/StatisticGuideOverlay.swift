//
//  StatisticGuideOverlay.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/16/24.
//

import SwiftUI

struct StatisticGuideOverlay: View {
    @Binding var isShowingGuide: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea(edges: .all)
                .onTapGesture {
                    isShowingGuide = false
                }
            
            VStack(spacing: 20) {
                Spacer()
                VStack(spacing: 8) {
                    Text("월간 요약 보는 법")
                        .font(.bold18)
                        .padding(.top, 20)
                    
                    Text("날짜 선택 시 요약을 볼 수 있습니다.")
                        .font(.medium11)
                        .foregroundStyle(.gray)
                        .padding(.bottom, 20)
                }
                
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "puzzlepiece.extension.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Color.partiallyCompletePuzzle)
                        Text("할 일 일부만 완료")
                            .font(.medium11)
                    }
                    
                    HStack(spacing: 8) {
                        Image(systemName: "puzzlepiece.extension.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Color.accent)
                        Text("할 일 전부 완료")
                            .font(.medium11)
                    }
                }
                
                Spacer()
                
                Button {
                    isShowingGuide = false
                } label: {
                    Text("확인")
                        .font(.medium16)
                        .foregroundStyle(.white)
                        .frame(width: 209, height: 40)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.bottom, 20)
            }
            .frame(width: 250, height: 286)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 10)
        }
    }
}
