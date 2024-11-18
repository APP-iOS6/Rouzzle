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
        VStack(spacing: 0) { // spacing을 0으로 설정
            HStack {
                Text("추천")
                    .font(.semibold18)
                    .foregroundStyle(.basic)
                    .padding(.leading)
                Spacer()
            }
            .padding(.top, 20)
            .padding(.bottom, 12) // 상단 타이틀과 카테고리 사이 간격

            RecommendCategoryView(selectedCategory: $viewModel.selectedCategory)
                .padding(.bottom, 20) // 카테고리와 카드리스트 사이 간격 고정
            
            RecommendCardListView(
                cards: $viewModel.filteredCards,
                selectedRecommendTask: $viewModel.selectedRecommend,
                allCheckBtn: $allCheckBtn
            ) { title, emoji, rotineItem in
                guard let routine = rotineItem else {
                    let userUid = Utils.getUserUUID()
                    addNewRoutine = RoutineItem(title: title, emoji: emoji, dayStartTime: [:], userId: userUid)
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
        .toastView(toast: $toast)
        .overlay {
            if viewModel.loadState == .loading {
                ProgressView()
            }
        }
        .onChange(of: viewModel.toastMessage) { _, new in
            guard let new else { return }
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
