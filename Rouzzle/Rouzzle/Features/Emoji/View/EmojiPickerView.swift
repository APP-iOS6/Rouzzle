//
//  EmojiPickerView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/8/24.
//

import SwiftUI

struct EmojiPickerView: View {
    @Binding var selectedEmoji: String
    @State private var viewModel: EmojiPickerViewModel?
    @AppStorage("recentEmojisData") private var recentEmojisData: String = "[]"
    @Environment(\.dismiss) private var dismiss
    var onEmojiSelected: (String) -> Void
    
    init(selectedEmoji: String, onEmojiSelected: @escaping (String) -> Void) {
        _selectedEmoji = .constant(selectedEmoji)  // 기본값 설정
        self.onEmojiSelected = onEmojiSelected
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let viewModel = viewModel {
                    ZStack {
                        Circle()
                            .fill(Color(.systemGray6))
                            .frame(width: 62, height: 62)
                            .overlay(
                                Circle()
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                                    .scaleEffect(viewModel.isEmojiSelected ? 1.2 : 1.0)
                                    .opacity(viewModel.isEmojiSelected ? 0 : 1)
                                    .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true),
                                               value: viewModel.isEmojiSelected)
                            )
                        
                        Text(selectedEmoji)
                            .font(.system(size: 30))
                            .scaleEffect(viewModel.isEmojiSelected ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6),
                                       value: viewModel.isEmojiSelected)
                    }
                    .padding(.top)
                    
                    SearchBar(text: Binding(
                        get: { viewModel.searchText },
                        set: { viewModel.searchText = $0 }
                    ))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(EmojiCategory.allCases, id: \.self) { category in
                                CategoryButton(
                                    category: category,
                                    isSelected: viewModel.selectedCategory == category,
                                    action: {
                                        viewModel.selectedCategory = category
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    ScrollView {
                        LazyVGrid(
                            columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4),
                            spacing: 16
                        ) {
                            ForEach(viewModel.filteredEmojis, id: \.self) { emoji in
                                Button(
                                    action: {
                                        selectedEmoji = emoji
                                        viewModel.selectEmoji(emoji)
                                        saveRecentEmojis()
                                    },
                                    label: {
                                        Text(emoji)
                                            .font(.system(size: 40))
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                            .frame(height: 70)
                                            .contentShape(Rectangle())
                                    }
                                )
                                .buttonStyle(EmojiButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                        .id(viewModel.selectedCategory)
                    }
                } else {
                    ProgressView()
                        .onAppear {
                            viewModel = EmojiPickerViewModel(recentEmojis: EmojiPickerView.loadRecentEmojis(from: recentEmojisData))
                        }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("완료") {
                        dismiss()
                    }
                }
            }
            .background(Color(uiColor: .systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .presentationDetents([.fraction(0.66)])
        .presentationCornerRadius(30)
        .presentationDragIndicator(.visible)
    }
    
    private static func loadRecentEmojis(from data: String) -> [String] {
        guard let data = data.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([String].self, from: data) else { return [] }
        return decoded
    }
    
    private func saveRecentEmojis() {
        if let encodedData = try? JSONEncoder().encode(viewModel?.recentEmojis),
           let jsonString = String(data: encodedData, encoding: .utf8) {
            recentEmojisData = jsonString
        }
    }
    
    private func handleEmojiSelection(_ emoji: String) {
        selectedEmoji = emoji
        onEmojiSelected(emoji)
        dismiss()
    }
}
