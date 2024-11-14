//
//  RecommendView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/11/24.
//

import SwiftUI
import SwiftData

struct RecommendView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = RecommendViewModel()
    @State private var toast: ToastModel?
    @State private var addNewRoutine: RoutineItem?
    @State private var allCheckBtn: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("추천")
                    .font(.semibold18)
                    .foregroundStyle(.basic)
                    .padding(.leading)
                Spacer()
            }
            .padding(.top, 20)

            RecommendCategoryView(selectedCategory: $viewModel.selectedCategory)
            
            RecommendCardListView(
                cards: $viewModel.filteredCards,
                selectedRecommendTask: $viewModel.selectedRecommend,
                allCheckBtn: $allCheckBtn
            ) { title, emoji, rotineItem in
                guard let routine = rotineItem else {
                    addNewRoutine = RoutineItem(title: title, emoji: emoji, dayStartTime: [:])
                    addNewRoutine?.taskList = viewModel.selectedRecommend.map { $0.toTaskList() }
                    return
                }
                Task {
                    await viewModel.addTask(routine, context: modelContext)
                    viewModel.selectedRecommend.removeAll()
                    allCheckBtn = false
                }
            }
            Spacer()
        }
        .toastView(toast: $toast) // ToastModifier 적용
        .overlay {
            if viewModel.loadState == .loading {
                ProgressView()
            }
        }
        .onChange(of: viewModel.toastMessage) { _, new in
            guard let new else {
                return
            }
            if viewModel.loadState == .completed {
                toast = ToastModel(type: .success, message: new)
                viewModel.toastMessage = nil
            } else {
                toast = ToastModel(type: .warning, message: new)
                viewModel.toastMessage = nil
            }
        }
        .fullScreenCover(item: $addNewRoutine) { routine in
            EditRoutineView(viewModel: EditRoutineViewModel(routine: routine), createRoutine: true) { title in
                viewModel.selectedRecommend.removeAll()
                allCheckBtn = false
                toast = ToastModel(type: .success, message: "\(title) 루틴이 추가되었습니다.")
                viewModel.toastMessage = nil
            }
        }
    }
}

#Preview {
    RecommendView()
}
