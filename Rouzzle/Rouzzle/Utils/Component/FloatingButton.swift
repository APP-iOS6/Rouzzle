//
//  FloatingButton.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/8/24.
//

import SwiftUI

struct FloatingButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.largeTitle)
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(Color.accentColor)
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    FloatingButton(action: {})
}
