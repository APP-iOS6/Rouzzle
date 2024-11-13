//
//  RoutineCompletion.swift
//  Rouzzle
//
//  Created by 김동경 on 11/6/24.
//

import Foundation
import FirebaseFirestore

struct RoutineCompletion: Codable {
    @DocumentID var documentId: String?
    var routineId: String // 루틴 id
    var userId: String // 유저 uid
    var date: Date // 완료 여부를 추적할 날짜
    var taskCompletions: [TaskCompletion] // 각 할 일의 완료 상태}
    
    /// TaskCompletion 완성 다 되었는지 확인하는 연산 프로퍼티
    var isCompleted: Bool {
        return taskCompletions.allSatisfy { $0.isComplete }
    }
}

struct TaskCompletion: Codable {
    var title: String // 할일 제목
    var emoji: String // 이모지
    var timer: Int // 할일 타이머
    var isComplete: Bool // 완성됨?
}
