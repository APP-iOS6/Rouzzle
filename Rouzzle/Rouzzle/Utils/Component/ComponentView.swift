//
//  ComponentView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import SwiftUI

struct ComponentView: View {
    @State var text: String = ""
    var body: some View {
        RouzzleTextField(text: $text, placeholder: "제목")
        RouzzleButton(buttonType: .save, action: {})
        EmojiButton(emojiButtonType: .routineEmoji)
    }
}

#Preview {
    ComponentView()
}
