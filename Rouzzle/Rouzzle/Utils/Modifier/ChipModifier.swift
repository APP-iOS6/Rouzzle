//
//  ChipModifier.swift
//  Rouzzle
//
//  Created by 김동경 on 11/5/24.
//

import SwiftUI

struct ChipModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(8)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.gray, lineWidth: 1)
            }
    }
}
