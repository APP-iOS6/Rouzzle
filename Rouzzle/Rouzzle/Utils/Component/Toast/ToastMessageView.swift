//
//  ContentView.swift
//  ToastTest2
//
//  Created by 이다영 on 11/13/24.
//

import SwiftUI

// 토스트메시지 종류별로 눌러보십쇼
struct ToastMessageView: View {
    @State private var toast: ToastModel?
    
    // 타입별로 아이콘이랑 배경색이 다릅니다! 메시지 입력해서 쓰세요!(get퍼즐만 고정)
    var body: some View {
        VStack {
            Button {
                toast = ToastModel(type: .info, message: "안내합니다")
            } label: {
                Text("안내")
            }
            Button {
                toast = ToastModel(type: .error, message: "오류네요")
            } label: {
                Text("오류")
            }
            Button {
                toast = ToastModel(type: .warning, message: "경고합니다")
            } label: {
                Text("경고")
            }
            Button {
                toast = ToastModel(type: .success, message: "성공적이네요")
            } label: {
                Text("성공")
            }
            Button {
                toast = ToastModel(type: .getOnePuzzle)
            } label: {
                Text("퍼즐1")
            }
            Button {
                toast = ToastModel(type: .getTwoPuzzle)
            } label: {
                Text("퍼즐2")
            }
        }
        .toastView(toast: $toast) // ToastModifier 적용
    }
}

#Preview {
    ToastMessageView()
}
