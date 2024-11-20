//
//  MonthSelector.swift
//  Rouzzle
//
//  Created by 김동경 on 11/19/24.
//

import SwiftUI

struct MonthSelector: View {
    
    let title: String
    @Binding var isLoading: Bool
    let action: (Int) -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            Button {
                action(-1)
            } label: {
                Image(systemName: "chevron.left")
                    .font(.regular14)
                    .foregroundStyle(Color.gray)
            }
            .disabled(isLoading)
            
            Text(title)
                .font(.regular14)
            
            Button {
                action(1)
            } label: {
                Image(systemName: "chevron.right")
                    .font(.regular14)
                    .foregroundStyle(Color.gray)
            }
            .disabled(isLoading)
        }
    }
}

#Preview {
    MonthSelector(title: "2024년 10월", isLoading: .constant(false)) { _ in }
}
