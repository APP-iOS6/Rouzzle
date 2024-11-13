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

    var body: some View {
        Text(displayedText)
            .font(font)
            .onChange(of: text) { newText in
                // 새로운 텍스트가 들어오면 애니메이션 재시작
                displayedText = ""
                currentIndex = 0
                startTypingAnimation(with: newText)
            }
            .onAppear {
                // 초기 텍스트 애니메이션 실행
                startTypingAnimation(with: text)
            }
    }
    
    private func startTypingAnimation(with newText: String) {
        displayedText = ""
        currentIndex = 0

        // 타이핑 애니메이션을 실행하는 타이머
        Timer.scheduledTimer(withTimeInterval: animationDelay, repeats: true) { timer in
            if currentIndex < newText.count {
                let index = newText.index(newText.startIndex, offsetBy: currentIndex)
                displayedText.append(newText[index])
                currentIndex += 1
            } else {
                timer.invalidate() // 애니메이션 완료 시 타이머 중지
            }
        }
    }
}
