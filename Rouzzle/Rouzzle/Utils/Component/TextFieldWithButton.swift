//
//  TextFieldWithButton.swift
//  Rouzzle
//
//  Created by 김정원 on 11/2/24.
//

import SwiftUI

struct TextEditorWithDismissableKeyboard: View {
    @Binding var text: String
    var height: CGFloat = 300
    var backgroundColor: Color = .white
    
    var body: some View {
        ScrollView {
            TextEditor(text: $text)
                .frame(height: height)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .foregroundColor(.primary)
                .padding()
                .background(backgroundColor)
                .cornerRadius(10)
        }
        .background(backgroundColor)
        .onTapGesture {
            hideKeyboard() // ScrollView 외부 터치 시 키보드 내리기
        }
    }
}
