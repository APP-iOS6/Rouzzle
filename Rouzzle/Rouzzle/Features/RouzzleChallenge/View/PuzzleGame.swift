//
//  PuzzleGame.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/15/24.
//

import SwiftUI

@Observable
class PuzzleGame {
    var puzzlePieceCount: Int
    var showNoPiecesAlert: Bool = false
    var isCompleted: Bool = false
    
    let puzzleType: PuzzleType
    
    init(puzzleType: PuzzleType, initialPieceCount: Int = 22) {
        self.puzzleType = puzzleType
        self.puzzlePieceCount = initialPieceCount
    }
    
    func usePuzzlePiece() -> Bool {
        if puzzlePieceCount > 0 {
            puzzlePieceCount -= 1
            return true
        } else {
            showNoPiecesAlert = true
            return false
        }
    }
}

enum PuzzleType {
    case tuna
    case ned
    case chan
    
    var imageName: String {
        switch self {
        case .tuna:
            return "tunapuzzle"
        case .ned:
            return "nedpuzzle"
        case .chan:
            return "chanpuzzle"
        }
    }
    
    // 퍼즐 조각 이미지 이름 생성 함수 추가
    func getPieceImageName(index: Int) -> String {
        let paddedIndex = String(format: "%02d", index + 1)
        switch self {
        case .tuna:
            return "tuna\(paddedIndex)"
        case .ned:
            return "ned\(paddedIndex)"
        case .chan:
            return "chan\(paddedIndex)"
        }
    }
}
