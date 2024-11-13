//
//  QuotesProvider.swift
//  Rouzzle
//
//  Created by 이다영 on 11/13/24.
//
import Foundation

struct QuotesProvider {
    static let quotes: [String] = [
        "끊임없이 남탓하고, 사고하지 말라",
        "늦었다고 생각할 때가 진짜 늦은거다",
        "참을 인 세번이면 호구",
        "인생은 한 방이 아니다",
        "시작은 시작이지 반이 아니다",
        "동바오의 첫사랑은 언제인가요?",
        "빨리 끝내라, 빨리 끝내라",
    ]
    
    static func randomQuote() -> String {
        return quotes.randomElement() ?? "명언 없음"
    }
}
