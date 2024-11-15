//
//  AddRoutineContainerView.swift
//  Rouzzle
//
//  Created by 김동경 on 11/15/24.
//

import SwiftUI

struct AddRoutineContainerView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: AddRoutineViewModel = .init()
    @State private var toast: ToastModel?

    var body: some View {
        VStack {
            HStack {
                Button {
                   goBack()
                } label: {
                    Image(systemName: viewModel.step == .info ? "xmark" : "chevron.left")
                        .font(.semibold18)
                }
                Spacer()
            }
            .overlay {
                Text(viewModel.step == .info ? "루틴 등록" : "할 일 등록")
                    .font(.semibold18)
                
            }
            .padding()
            
            ProgressView(value: viewModel.step.rawValue, total: 1.0)
                .tint(.accent)
                .progressViewStyle(.linear)
                .padding(.horizontal)
            
            switch viewModel.step {
            case .info:
                AddRoutineView(viewModel: viewModel)
            case .task:
                AddRoutineTaskView(viewModel: viewModel)
            }
            Spacer()
        }
        .toastView(toast: $toast) // ToastModifier 적용
        .overlay {
            if viewModel.loadState == .loading {
                ProgressView()
            }
        }
        .onChange(of: viewModel.loadState) { _, new in
            if new == .completed {
                dismiss()
            }
        }
        .onChange(of: viewModel.toastMessage, { _, new in
            guard let new else {
                return
            }
            toast = ToastModel(type: .warning, message: new)
        })
        .animation(.easeInOut(duration: 0.1), value: viewModel.step)
    }
    private func goBack() {
        switch viewModel.step {
        case .info:
            dismiss()
        case .task:
            viewModel.step = .info
        }
    }
}

#Preview {
    AddRoutineContainerView()
}
