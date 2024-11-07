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
    @Binding var selectedEmoji: String?
    private(set) var emojiButtonType: EmojiButtonType
    var onEmojiSelected: (String) -> Void
    
    // selectedEmoji가 optional binding이 아닌 경우를 위한 생성자
    init(emojiButtonType: EmojiButtonType, onEmojiSelected: @escaping (String) -> Void) {
        self._selectedEmoji = .constant(nil)
        self.emojiButtonType = emojiButtonType
        self.onEmojiSelected = onEmojiSelected
    }
    
    // selectedEmoji가 binding으로 전달되는 경우를 위한 생성자
    init(selectedEmoji: Binding<String?>, emojiButtonType: EmojiButtonType, onEmojiSelected: @escaping (String) -> Void) {
        self._selectedEmoji = selectedEmoji
        self.emojiButtonType = emojiButtonType
        self.onEmojiSelected = onEmojiSelected
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Button(action: {
                    hideKeyboard()
                    showSheet.toggle()
                }, label: {
                    if let emoji = selectedEmoji {
                        Text(emoji)
                            .font(.system(size: emojiButtonType.fontSize))
                    } else {
                        emojiButtonType.view
                    }
                })
            }
        }
        .sheet(isPresented: $showSheet) {
            // 여기를 수정
            EmojiPickerView(
                selectedEmoji: selectedEmoji ?? "😊",  // String 타입으로 전달
                onEmojiSelected: { emoji in
                    selectedEmoji = emoji
                    onEmojiSelected(emoji)
                    showSheet = false
                }
            )
        }
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
