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
                    withAnimation {
                        isShowingGuide = false
                    }
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
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 5) {
                        Circle()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(Color.partiallyCompletePuzzle)
                        Text(": 할 일 일부만 완료")
                            .font(.medium14)
                    }
                    
                    HStack(spacing: 5) {
                        Circle()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(Color.calendarCompleted)
                        Text(": 할 일 전부 완료")
                            .font(.medium14)
                    }
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        isShowingGuide = false
                    }
                } label: {
                    Text("확인")
                        .font(.medium16)
                        .foregroundStyle(.white)
                        .frame(width: 209, height: 40)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.bottom, 30)
            }
            .frame(width: 250, height: 286)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
