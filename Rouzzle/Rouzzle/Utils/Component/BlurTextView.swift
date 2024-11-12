//
//  BlurTextView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/12/24.
//

import SwiftUI

struct BlurTextView: View {
    let characters: [String.Element]
    let baseTime: Double
    let font: Font
    @State var blurValue: Double = 10
    @State var opacity: Double = 0

    init(text: String, font: Font, startTime: Double) {
        self.characters = Array(text)
        self.font = font
        self.baseTime = startTime
    }

    var body: some View {
        HStack(spacing: 1) {
            ForEach(0..<characters.count, id: \.self) { num in
                Text(String(self.characters[num]))
                    .font(font)
                    .blur(radius: blurValue)
                    .opacity(opacity)
                    .animation(.easeInOut.delay(Double(num) * 0.15), value: blurValue)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + baseTime) {
                blurValue = 0
                opacity = 1
            }
        }
    }
}
