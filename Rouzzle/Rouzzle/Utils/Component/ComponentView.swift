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

    var body: some View {
        VStack {
            RouzzleTextField(text: $text, placeholder: "제목")
            
            RouzzleButton(buttonType: .save, action: {})
                .padding(.vertical)
            
            EmojiButton(emojiButtonType: .keyboard) { emoji in
                print(emoji) // 여기서 이모지 전달받습니다.
            }
            
            TaskStatusPuzzle(taskStatus: .pending)
            
            RoutineStatusPuzzle(status: .pending)
            
            RecommendTask(isPlus: false)
            
            RecommendTaskByTime(category: .morning)
            
            Spacer()
        }
        .padding()
        
    }
}

#Preview {
    ComponentView()
}
