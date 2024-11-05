//
//  EmojiView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import SwiftUI
enum EmojiButtonType {
    case keyboard
    case routineEmoji
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .keyboard:
            KeyboardEmojiButton()
        case .routineEmoji:
            PrimaryEmojiButton()
        }
    }
    
    var fontSize: CGFloat {
        switch self {
        case .keyboard:
            return 24
        case .routineEmoji:
            return 70
        }
    }
}

struct EmojiButton: View {
    @State private var showSheet = false
    @State private var selectedEmoji: String?
    private(set) var emojiButtonType: EmojiButtonType
    var onEmojiSelected: (String) -> Void

    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Button(action: {
                    hideKeyboard() // 키보드 숨기기
                    showSheet.toggle()
                }, label: {
                    if let emoji = selectedEmoji {
                        Text(emoji) // 선택된 이모지를 표시
                            .font(.system(size: emojiButtonType.fontSize))
                    } else {
                        emojiButtonType.view
                    }
                })
            }
        }
        .sheet(isPresented: $showSheet) {
            EmojiListView { emoji in
                self.selectedEmoji = emoji
                self.showSheet = false
            }
            .presentationDetents([.fraction(0.5)])
        }
    }
}

#Preview {
    EmojiButton(emojiButtonType: .keyboard, onEmojiSelected: { _ in})
}

struct EmojiListView: View {
    @State private var selectedEmoji: String? 
    var onEmojiSelected: (String) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(getEmojiList(), id: \.self) { row in
                    HStack(spacing: 25) {
                        ForEach(row, id: \.self) { code in
                            Button(action: {
                                if let emoji = UnicodeScalar(code)?.properties.isEmoji == true ? String(UnicodeScalar(code)!) : nil {
                                    onEmojiSelected(emoji) // 이모지를 상위 뷰로 전달
                                }
                            }) {
                                if let emoji = UnicodeScalar(code)?.properties.isEmoji == true ? String(UnicodeScalar(code)!) : nil {
                                    Text(emoji).font(.system(size: 55))
                                }
                            }
                        }
                    }
                }
            }
            .padding(.top)
        }
        .background(Color.white)
    }
    
    /// 유니코드 이모지 목록을 가져오는 함수
    func getEmojiList() -> [[Int]] {
        var emojis: [[Int]] = []
        for i in stride(from: 0x1F601, to: 0x1F64F, by: 4) {
            var row: [Int] = []
            for j in i...i+3 {
                row.append(j)
            }
            emojis.append(row)
        }
        return emojis
    }
}

struct KeyboardEmojiButton: View {
    var body: some View {
        Image(systemName: "circle.dotted")
            .font(.system(size: 24))
    }
}

struct PrimaryEmojiButton: View {
    var body: some View {
        Circle()
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [2, 5]))
            .frame(width: 62, height: 62)
            .overlay {
                Image(systemName: "plus")
                    .font(.largeTitle)
            }
    }
}
