//
//  StrokeTextFieldModifier.swift
//  Rouzzle
//
//  Created by 김동경 on 11/5/24.
//

import SwiftUI

struct StrokeTextFieldModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .textInputAutocapitalization(.never)
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.gray, lineWidth: 1)
            }
    }
}
