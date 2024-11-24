//
//  RouzzleTextField.swift
//  Rouzzle
//
//  Created by 김정원 on 11/3/24.
//

import SwiftUI

struct RouzzleTextField: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.white)
            .clipShape(.rect(cornerRadius: 12))
    }
}
