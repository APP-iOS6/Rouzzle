//
//  NavigationBackButtonModifier.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import SwiftUI

struct NavigationBackButtonModifier: ViewModifier {
    var title: String
    @Environment(\.presentationMode) var presentationMode

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true) // 기본 뒤로가기 버튼 숨김
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .font(.semibold20)
                    })
                }
                ToolbarItem(placement: .principal) { // 중앙에 타이틀을 추가
                    Text(title)
                        .font(.semibold18) // 원하는 폰트 스타일 설정
                        .foregroundColor(.primary) // 원하는 색상으로 설정 가능
                }
            }
            .navigationTitle("\(title)")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
    }
}

extension View {
    /// title : 네비게이션 제목
    func customNavigationBar(title: String) -> some View {
        self.modifier(NavigationBackButtonModifier(title: title))
    }
}
