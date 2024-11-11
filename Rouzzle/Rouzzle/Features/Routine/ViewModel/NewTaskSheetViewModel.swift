//
//  NewTaskSheetViewModel.swift
//  Rouzzle
//
//  Created by 김동경 on 11/7/24.
//

import Factory
import Foundation
import Observation

@Observable
final class NewTaskSheetViewModel {
    
    @ObservationIgnored
    @Injected(\.routineService) private var routineService
    
    init() {
        print("시트뷰모델")
    }
    
    var emoji: String?
    var text: String = ""
    var hour: Int = 0
    var min: Int = 0
    var second: Int = 0
    var errorMessage: String?
    var sheetType: SheetType = .task
    var loadState: LoadState = .none
    
    @MainActor
    func updateRoutineTask(_ routine: RoutineItem, task: RoutineTask) async {
        loadState = .loading
        // 스데 루틴 모델을 파베 루틴 모델로 변환 후 할일 추가해서 업데이트하기
        var routine = routine.toRoutine()
        routine.routineTask.append(task)
        print(routine.documentId ?? "없음")
        
        let result = await routineService.updateRoutine(routine)
        switch result {
        case .success(()):
            loadState = .completed
        case let .failure(error):
            errorMessage = "할일 추가에 실패했습니다 다시 시도해 주세요."
            loadState = .failed
            print(error.localizedDescription)
        }
    }
}

enum SheetType: Hashable {
    case task
    case time
}
