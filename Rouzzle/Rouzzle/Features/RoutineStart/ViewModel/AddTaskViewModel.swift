//
//  AddTaskViewModel.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/19/24.
//

import Foundation
import Observation
import Factory
import SwiftData

@Observable
class AddTaskViewModel {
    @Injected(\.routineService) @ObservationIgnored private var routineService
    var toast: ToastModel?
    var loadState: LoadState = .none

    /// 루틴 삭제 함수
    func deleteRoutine(
        routineItem: RoutineItem,
        modelContext: ModelContext,
        completeAction: @escaping (String) -> Void,
        dismiss: @escaping () -> Void
    ) {
        Task {
            loadState = .loading
            let routineToDelete = routineItem.toRoutine()
            
            // RoutineCompletion 삭제
            let completionDeleteResult = await routineService.removeRoutineCompletions(for: routineToDelete.documentId ?? "")
            switch completionDeleteResult {
            case .success:
                print("✅ RoutineCompletion 삭제 성공")
            case .failure(let error):
                print("❌ RoutineCompletion 삭제 실패: \(error.localizedDescription)")
                loadState = .failed
                return
            }
            
            // Firestore 루틴 삭제
            let firebaseResult = await routineService.removeRoutine(routineToDelete)
            switch firebaseResult {
            case .success:
                print("✅ 파이어베이스 루틴 삭제 성공")
            case .failure(let error):
                print("❌ 파이어베이스 루틴 삭제 실패: \(error.localizedDescription)")
                loadState = .failed
                return
            }

            // SwiftData에서 삭제
            do {
                try SwiftDataService.deleteRoutine(routine: routineItem, context: modelContext)
                print("✅ 스위프트 데이터 루틴 삭제 성공")
                completeAction("루틴이 삭제되었습니다.")
            } catch {
                print("❌ 스위프트 데이터 루틴 삭제 실패: \(error.localizedDescription)")
                loadState = .failed
                return
            }
            loadState = .completed
            dismiss()
        }
    }
}
