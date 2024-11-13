//
//  ToastModifier.swift
//  ToastTest2
//
//  Created by 이다영 on 11/13/24.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var toast: ToastModel?
    @State private var workItem: DispatchWorkItem?
    @State private var opacity: Double = 0

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainToastView()
                        .opacity(opacity)
                }
                .animation(.easeInOut(duration: 0.3), value: opacity)
            )
            .onChange(of: toast) {
                if toast != nil {
                    print("Toast type: \(String(describing: toast?.type))")
                    showToast()
                }
            }
    }

    @ViewBuilder func mainToastView() -> some View {
        if let toast = toast {
            VStack {
                // 퍼즐 조각 얻기(+1,+2)
                if toast.type == .getOnePuzzle || toast.type == .getTwoPuzzle {
                    HStack {
                        Image("Piece")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text(toast.message)
                            .foregroundColor(.white)
                            .font(.regular16)
                    }
                    .padding()
                    .background(toast.type.themeColor)
                    .shadow(radius: 5)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding(.top, 50)
                    .onAppear {
                        print("getPuzzle toast 띄우기")
                    }
                } else {
                    ToastView(
                        message: toast.message,
                        icon: Image(systemName: toast.type.iconFileName),
                        backgroundColor: toast.type.themeColor.opacity(0.8),
                        textColor: .white,
                        duration: toast.duration,
                        isShowing: Binding(
                            get: { self.toast != nil },
                            set: { isShowing in if !isShowing { self.toast = nil } }
                        )
                    )
                    .padding(.top, 50)
                }
                Spacer()
            }
        }
    }

    private func showToast() {
        workItem?.cancel()
        guard let toast = toast else { return }

        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        withAnimation {
            opacity = 1.0
        }

        workItem = DispatchWorkItem {
            dismissToast()
        }

        if let workItem = workItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: workItem)
        }
    }

    private func dismissToast() {
        withAnimation {
            opacity = 0.0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            toast = nil
            workItem?.cancel()
            workItem = nil
        }
    }
}

extension View {
    func toastView(toast: Binding<ToastModel?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}
