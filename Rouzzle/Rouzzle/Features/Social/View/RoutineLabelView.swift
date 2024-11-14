//
//  RoutineLabelView.swift
//  Rouzzle
//
//  Created by 이다영 on 11/11/24.
//

import SwiftUI

struct RoutineLabelView: View {
    var text: String
    var isSelected: Bool
    var onTap: () -> Void

    var body: some View {
        Text(text)
            .font(.semibold12)
            .foregroundColor(isSelected ? .black : .gray)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.white : Color.clear)
                    .stroke(isSelected ? Color.accentColor : Color.gray, lineWidth: 1)
            )
            .onTapGesture {
                onTap()
            }
            .frame(height: 28)
    }
}
#Preview {
    RoutineLabelView(text: "저녁 루틴", isSelected: false, onTap: {})
}
