//
//  ToastView.swift
//  ToastTest2
//
//  Created by 이다영 on 11/13/24.
//

import SwiftUI

// 커스텀 토스트 메시지를 표시하는 ToastView
struct ToastView: View {
    let message: String // 토스트 메시지 내용
    var icon: Image? // 선택적으로 표시할 아이콘
    var backgroundColor: Color = Color.black.opacity(0.8) // 배경 색상
    var textColor: Color = .white // 텍스트 색상
    var duration: Double = 2.0 // 토스트 표시 시간 (초 단위)
    
    @Binding var isShowing: Bool // 토스트 표시 상태 관리
    @State private var offset: CGFloat = 0 // 토스트 위치 조정을 위한 오프셋
    
    var body: some View {
        VStack {
            if isShowing {
                VStack {
                    // 상단에 토스트 콘텐츠 표시
                    toastContent
                        .transition(.move(edge: .top).combined(with: .opacity)) // 상단에서 슬라이드-인 애니메이션
                    Spacer() // 하단 여백
                }
                .edgesIgnoringSafeArea(.all) // 화면의 가장자리를 넘어서 렌더링
                .onAppear {
                    withAnimation {
                        // 지정된 시간 후에 토스트를 자동으로 숨김
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            withAnimation {
                                self.isShowing = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    // 토스트 콘텐츠의 레이아웃 정의
    private var toastContent: some View {
        HStack(spacing: 10) {
            // 아이콘이 있으면 표시
            if let icon = icon {
                icon
                    .foregroundColor(textColor)
            }
            // 메시지 텍스트 표시
            Text(message)
                .foregroundColor(textColor)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(backgroundColor) // 배경 색상 설정
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding(.horizontal, 20)
        .shadow(radius: 5)
    }
}
