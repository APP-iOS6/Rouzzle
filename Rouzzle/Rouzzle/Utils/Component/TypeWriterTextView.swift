//
//  BlurTextView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/12/24.
//

import SwiftUI

struct TypeWriterTextView: View {
    let characters: [String.Element]
        let font: Font
        let animationDelay: Double
        
        @State private var shownIndices: Set<Int> = [] // 나타난 글자 인덱스를 추적

        init(text: String, font: Font, animationDelay: Double) {
            self.characters = Array(text)
            self.font = font
            self.animationDelay = animationDelay
        }

        var body: some View {
            HStack(spacing: 1) {
                ForEach(0..<characters.count, id: \.self) { index in
                    Text(String(self.characters[index]))
                        .font(font)
                        .opacity(shownIndices.contains(index) ? 1 : 0) // 나타난 글자만 불투명하게
                        .animation(.easeIn(duration: 0.05).delay(Double(index) * animationDelay), value: shownIndices)
                }
            }
            .onAppear {
                for index in characters.indices {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * animationDelay) {
                        shownIndices.insert(index) // 순차적으로 인덱스 추가해 글자 나타나게 함
                    }
                }
            }
        }
}
