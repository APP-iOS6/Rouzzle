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
    
    init(puzzleType: PuzzleType, initialPieceCount: Int = 23) {
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
            return "tunapuzzle" // 임시로 tuna 이미지 사용
        case .chan:
            return "tunapuzzle" // 임시로 tuna 이미지 사용
        }
    }
}
