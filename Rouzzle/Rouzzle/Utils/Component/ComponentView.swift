//
//  ComponentView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import SwiftUI

struct ComponentView: View {
    @State var text: String = ""
    @State private var emojiText = ""
    @State private var selectedEmoji: String? = "🧩"
    
    var body: some View {
        ScrollView {
            VStack {
                RouzzleTextField(text: $text, placeholder: "제목")
                
                RouzzleButton(buttonType: .save, action: {})
                    .padding(.vertical)
                
                EmojiButton(
                    selectedEmoji: $selectedEmoji,
                    emojiButtonType: .keyboard
                ) { emoji in
                    print("Selected Emoji: \(emoji)")
                }
                
                TaskStatusPuzzle(taskStatus: .pending)
                
                RoutineStatusPuzzle(status: .pending)
                
                RecommendTaskByTime(category: .morning)
                
                DashedVerticalLine()
                
                RecommendTask(isPlus: false)
                
            }
            .padding()
        }
    }
}

#Preview {
    ComponentView()
}
