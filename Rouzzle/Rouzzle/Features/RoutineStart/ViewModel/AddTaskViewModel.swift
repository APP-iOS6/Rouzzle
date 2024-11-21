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
    
    var isRoutineRunning: Bool = false
    
    func startRoutine() {
        isRoutineRunning = true
        print("루틴이 시작되었습니다. 실행 상태: \(isRoutineRunning)")
        
        // 기존 알림 제거
        NotificationManager.shared.removeAllNotifications()
    }
    
    func stopRoutine() {
        isRoutineRunning = false
        print("루틴이 종료되었습니다. 실행 상태: \(isRoutineRunning)")
    }

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
