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
    @State private var isPlus: Bool = true
    
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
                
                // TaskStatusPuzzle(taskStatus: .pending)
                
              //  TaskStatusRow(taskStatus: .pending, showEditIcon: .constant(false), showDeleteIcon: .constant(false))
                
              //  RoutineStatusPuzzle(status: .pending)
                
                RecommendTask(isPlus: $isPlus) {}
                
                FloatingButton(action: {})
            }
            .padding()
        }
    }
}

#Preview {
    ComponentView()
}
