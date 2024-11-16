//
//  BorderButtonModifier.swift
//  Rouzzle
//
//  Created by 김동경 on 11/15/24.
//

import SwiftUI

struct BorderButtonModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(height: 61)
            .frame(maxWidth: .infinity)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.accent, lineWidth: 1)
            }
    }
}
