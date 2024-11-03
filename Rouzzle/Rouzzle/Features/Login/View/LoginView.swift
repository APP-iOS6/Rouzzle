//
//  LoginView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/2/24.
//

import SwiftUI

struct LoginView: View {
    @State private var text = ""
    
    var body: some View {
        VStack {
            RouzzleTextField(text: $text, placeholder: "새롭게 할 일을 입력해주세요.")
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
