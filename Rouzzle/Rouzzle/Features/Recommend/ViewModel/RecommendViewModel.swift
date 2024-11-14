//
//  RecommendViewModel.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/11/24.
//

import Factory
import Foundation
import SwiftData
@Observable
final class RecommendViewModel {
    
    @ObservationIgnored
    @Injected(\.routineService) private var routineService
    
    enum Category: String, CaseIterable {
        case celebrity = "유명인"
        case morning = "아침"
        case evening = "저녁"
        case health = "건강"
        case pet = "반려동물"
        case productivity = "생산성"
        case rest = "휴식"
    }
    
    var loadState: LoadState = .none
    var toastMessage: String?
    var selectedCategory: Category = .celebrity {
        didSet {
            updateCards()
        }
    }
    
    var filteredCards: [Card] = []
    var selectedRecommend: [RecommendTodoTask] = []
    
    private let allCards: [Category: [Card]] = [
        .celebrity: DummyCardData.celebrityCards,
        .morning: DummyCardData.morningCards,
        .evening: DummyCardData.eveningCards,
        .health: DummyCardData.healthCards,
        .pet: DummyCardData.petCards,
        .productivity: DummyCardData.productivityCards,
        .rest: DummyCardData.restCards
    ]
    
    init() {
        updateCards()
    }
    
    private func updateCards() {
        filteredCards = allCards[selectedCategory] ?? []
    }
    
    @MainActor
    func addTask(_ routineItem: RoutineItem, context: ModelContext) async {
        loadState = .loading
        var routine = routineItem.toRoutine()
        for task in selectedRecommend {
            routine.routineTask.append(task.toRoutineTask())
        }
        
        let result = await routineService.updateRoutine(routine)
        switch result {
        case .success:
            do {
                for task in selectedRecommend {
                    try SwiftDataService.addTask(to: routineItem, task.toTaskList(), context: context)
                }
                loadState = .completed
                toastMessage = "\(routineItem.title) 에 할 일을 추가하였습니다"
            } catch {
                loadState = .failed
                toastMessage = "루틴 추가에 실패했습니다"
            }
        case .failure:
            loadState = .failed
            toastMessage = "루틴 추가에 실패했습니다"
        }
        
    }
}

@Observable
final class DetailViewModel {
    var selectedTasks: Set<String> = []
    
    func saveSelectedTasks() {
        // 저장 로직 구현
        print("선택된 작업 저장: \(selectedTasks)")
    }
}
