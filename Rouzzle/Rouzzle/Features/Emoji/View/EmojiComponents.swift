//
//  EmojiComponents.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/8/24.
//

import SwiftUI

struct EmojiButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(configuration.isPressed ? Color.gray.opacity(0.2) : Color.clear)
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct CategoryButton: View {
    let category: EmojiCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(category.rawValue)
                .font(.regular14)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.themeColor : Color.gray.opacity(0.2))
                )
                .foregroundColor(isSelected ? .basic : .basic)
        }
        .buttonStyle(PlainButtonStyle())
        
    }
    
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .padding(.leading)
                .foregroundColor(.gray)
            
            TextField("이모지 검색", text: $text)
                .padding(.trailing, 8)
                .font(.regular12)
            
            if !text.isEmpty {
                Button(
                    action: {
                        text = ""
                    },
                    label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                )
                .padding(.trailing, 8)
            }
        }
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding()
    }
}
