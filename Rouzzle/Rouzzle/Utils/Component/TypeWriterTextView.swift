//
//  BlurTextView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/12/24.
//

import SwiftUI

struct TypeWriterTextView: View {
    @Binding var text: String // 바인딩으로 텍스트 받아옴
    let font: Font
    let animationDelay: Double

    @State private var displayedText: String = ""
    @State private var currentIndex: Int = 0
    @State private var timer: Timer? // 기존 타이머를 취소하기 위해 타이머 인스턴스를 저장

    var body: some View {
        Text(displayedText)
            .font(font)
            .onAppear {
                startTypingAnimation()
            }
            .onChange(of: text) {
                resetAnimation()
            }
            .onDisappear {
                timer?.invalidate() // 뷰가 사라질 때 타이머 정리
            }
    }
    
    private func startTypingAnimation() {
        displayedText = ""
        currentIndex = 0

        // 타이핑 애니메이션을 실행하는 타이머
        timer = Timer.scheduledTimer(withTimeInterval: animationDelay, repeats: true) { timer in
            if currentIndex < text.count {
                let index = text.index(text.startIndex, offsetBy: currentIndex)
                displayedText.append(text[index])
                currentIndex += 1
            } else {
                timer.invalidate() // 애니메이션 완료 시 타이머 중지
            }
        }
    }
    
    private func resetAnimation() {
        timer?.invalidate() // 기존 타이머 무효화
        displayedText = ""
        currentIndex = 0
        startTypingAnimation()
    }
}
