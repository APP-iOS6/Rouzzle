//
//  QuotesProvider.swift
//  Rouzzle
//
//  Created by 이다영 on 11/13/24.
//
import Foundation

class QuotesProvider {
    static let shared = QuotesProvider() // 싱글톤 인스턴스

    private var shuffledQuotes: [String]
    private var currentIndex: Int = 0

    private init() {
        self.shuffledQuotes = Self.quotes.shuffled()
    }

    static let quotes: [String] = [
        "\"오늘 행복하지 않다면, 내일도 행복하기 어렵다\"",
        "\"위대한 일은 편안한 지대에서 이루어지지 않는다\"",
        "\"습관이란 어떤 일이든지 하게 만든다\"",
        "\"생활은 습관이 짜낸 천에 불과하다\"",
        "\"비범함은 무수한 평범함이 쌓인 결과물이다\"",
//        "\"동바오의 첫사랑은 언제인가요?\"",
        "\"천 리 길도 한 걸음부터\"",
        "\"남을 이기려 하기보다 어제의 나를 이겨라\"",
        "\"꾸준함이 재능을 이긴다\"",
        "\"시간은 되돌릴 수 없으니 지금을 살아라\""
    ]

    func nextQuote() -> String {
        // 현재 인덱스의 명언 반환
        let quote = shuffledQuotes[currentIndex]
        currentIndex += 1

        // 모든 명언을 순회하면 셔플하고 다시 시작
        if currentIndex >= shuffledQuotes.count {
            currentIndex = 0
            shuffledQuotes.shuffle()
        }

        return quote
    }
}
