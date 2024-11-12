//
//  RoutineLabelView.swift
//  Rouzzle
//
//  Created by 이다영 on 11/11/24.
//

import SwiftUI

struct RoutineLabelView: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.semibold12)
            .foregroundColor(.black)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.accent, lineWidth: 1)
                    .fill(Color.white)
            )
    }
}

#Preview {
    RoutineLabelView(text: "저녁 루틴")
}
