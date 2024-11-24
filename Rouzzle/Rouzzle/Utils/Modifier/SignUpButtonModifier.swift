//
//  SignUpButtonModifier.swift
//  Rouzzle
//
//  Created by 김동경 on 11/3/24.
//

import SwiftUI

struct SignUpButtonModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 60)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white)
            )
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(uiColor: .systemGray5), lineWidth: 1)
            )
            .padding(.horizontal)
    }
}
