//
//  ContentView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/1/24.
//

import SwiftUI

struct ContentView: View {
    @State private var inputText = ""

    var body: some View {
        VStack {
            TextEditorWithDismissableKeyboard(text: $inputText, height: 100, backgroundColor: .white)
    
            Text("입력한 내용: \(inputText)")
                .padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
