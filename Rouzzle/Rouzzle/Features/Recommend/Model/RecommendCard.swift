//
//  RecommendCard.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/11/24.
//

import Foundation

struct Card: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let fullText: String
    let routines: [RoutineTask]
}

// MARK: - 더미 데이터
struct DummyCardData {
    static let celebrityCards: [Card] = [
        Card(
            title: "오타니 쇼헤이",
            imageName: "⚾️",
            fullText: "오타니 쇼헤이는 세계적인 야구 선수로, 그의 하루는 철저한 관리와 노력으로 이루어져 있습니다. 아침부터 밤까지 최상의 컨디션을 유지하기 위한 특별한 루틴을 따릅니다.",
            routines: [
                RoutineTask(title: "새벽 기상 및 스트레칭", emoji: "🙆🏻", timer: 15),
                RoutineTask(title: "아침 웨이트 훈련", emoji: "🏃", timer: 60),
                RoutineTask(title: "점심 고단백 식단", emoji: "🍱", timer: 30),
                RoutineTask(title: "야간 회복 운동", emoji: "🌌", timer: 30)
            ]
        )
    ]
    static let morningCards: [Card] = [
        Card(
            title: "모닝 요가",
            imageName: "🧘‍♀️",
            fullText: "하루를 활기차게 시작하는 15분 모닝 요가.",
            routines: []
        )
    ]
    static let eveningCards: [Card] = []
    static let healthCards: [Card] = []
    static let petCards: [Card] = []
    static let productivityCards: [Card] = []
    static let restCards: [Card] = []
}
