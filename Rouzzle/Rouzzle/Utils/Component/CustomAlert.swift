//
//  SwiftUIView.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/11/24.
//

import SwiftUI

extension View {
    func customAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        primaryButtonTitle: String,
        primaryAction: @escaping () -> Void
    ) -> some View {
        return modifier(
            CustomAlertViewModifier(
                isPresented: isPresented,
                title: title,
                message: message,
                primaryButtonTitle: primaryButtonTitle,
                primaryAction: primaryAction
            )
        )
    }
}

private struct CustomAlertViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let primaryButtonTitle: String
    let primaryAction: () -> Void

    func body(content: Content) -> some View {
        ZStack {
            content
                .blur(radius: isPresented ? 2 : 0)

            ZStack {
                if isPresented {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .transition(.opacity)

                    CustomAlert(
                        isPresented: self.$isPresented,
                        title: self.title,
                        message: self.message,
                        primaryButtonTitle: self.primaryButtonTitle,
                        primaryAction: self.primaryAction
                    )
                    .transition(.opacity)
                }
            }
            // 암시적 애니메이션
            .animation(.snappy, value: isPresented)
        }
    }
}

private struct CustomAlert: View {
    /// Alert 를 트리거 하기 위한 바인딩 필요
    @Binding var isPresented: Bool
    
    /// Alert 의 제목
    let title: String

    /// Alert 의 설명
    let message: String
    
    /// 주요 버튼에 들어갈 텍스트
    let primaryButtonTitle: String
    
    /// 주요 버튼이 눌렸을 때의 액션 (클로저가 필요함!)
    let primaryAction: () -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            VStack(spacing: 20) {
                Spacer()
                
                Text(title)
                    .font(.semibold18)
                
                if !message.isEmpty {
                    Text(message)
                        .font(.regular16)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
            }
            .frame(width: 280, height: 130)

            VStack(spacing: 0) {
                Divider()
                
                HStack {
                    Button {
                        isPresented = false // Alert dismiss
                    } label: {
                        Text("취소")
                            .font(.regular16)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .foregroundStyle(.black)
                    }
                    
                    Divider()
                    
                    Button {
                        isPresented = false // Alert dismiss
                        primaryAction() // 클로저 실행
                    } label: {
                        Text(primaryButtonTitle)
                            .font(.regular16)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .foregroundStyle(.red)
                    }
                }
            }
            .frame(height: 50)
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .frame(width: 280, height: 180)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
//                .strokeBorder(.accent, lineWidth: 1) // 크기 확인용(주석 예정)
        )
    }
}

#Preview {
    CustomAlert(
        isPresented: .constant(true),
        title: "정말 탈퇴하시겠어요?",
        message: "탈퇴 버튼 선택 시, 계정은\n삭제되며 복구되지 않습니다.",
        primaryButtonTitle: "탈퇴",
        primaryAction: { }
    )
}
