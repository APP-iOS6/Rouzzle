//
//  PieceCounter.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/12/24.
//

import SwiftUI

struct PieceCounter: View {
    let count: Int
    
    var body: some View {
        HStack {
            Image(.piece)
                .resizable()
                .scaledToFit()
                .frame(height: 18)
            
            Text("\(count)")
                .font(.medium16)
        }
        .frame(width: 70, height: 30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: .black.opacity(0.1), radius: 2)
        )
    }
}

#Preview {
    PieceCounter(count: 9)
}
