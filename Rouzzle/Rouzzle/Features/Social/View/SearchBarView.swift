//
//  SearchBarView.swift
//  Rouzzle
//
//  Created by 이다영 on 11/11/24.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var text: String
    private var isEditing: Bool {
        text.isEmpty
    }
    
    var body: some View {
        HStack {
            TextField("", text: $text, prompt: Text("루즐러를 검색해보세요.").font(.regular16))
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer() // 오른쪽 정렬을 위해 Spacer 사용
                        Button {
                            hideKeyboard()
                        } label: {
                            Image(systemName: "keyboard.chevron.compact.down")
                        }
                    }
                }
                .onSubmit {
                    hideKeyboard()
                }
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.graylittlelight))
                .cornerRadius(8)
//                .padding(.horizontal, 10)
                .overlay {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                }
            if !text.isEmpty {
                Button {
                    withAnimation {
                        text = ""
                    }
                } label: {
                    Text("Cancel")
                        .font(.regular16)
                }
            }
        }
    }
}

#Preview {
    SearchBarView(text: .constant(""))
}
