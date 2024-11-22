//
//  PuzzleGame.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/15/24.
//

import SwiftUI

// MARK: - PuzzleType Enum
enum PuzzleType: String, Codable {
    case tuna
    case ned
    case chan
    
    var imageName: String {
        switch self {
        case .tuna: return "tunapuzzle"
        case .ned: return "nedpuzzle"
        case .chan: return "chanpuzzle"
        }
    }
    
    func getPieceImageName(index: Int) -> String {
        let paddedIndex = String(format: "%02d", index + 1)
        return "\(self.rawValue)\(paddedIndex)"
    }
}

// MARK: - 퍼즐의 전체 상태를 저장(각 퍼즐 타입별로 독립적으로 저장됨)
struct PuzzleState: Codable {
    var placedPieces: [PlacedPieceInfo]  // 배열로 배치된 퍼즐 조각들의 정보 관리
    var completionDate: Date?            // 퍼즐 완성 시점
    var remainingPieces: Int            // 남은 사용 가능한 퍼즐 조각 수
}

// 개별 퍼즐 조각의 상태 정보를 저장
struct PlacedPieceInfo: Codable {
    let pieceName: String               // 퍼즐 조각의 고유 식별자 (예: tuna01)
    let position: PiecePosition         // 퍼즐 조각의 현재 위치
    let isPlaced: Bool                  // 올바른 위치에 배치 여부
}

struct PiecePosition: Codable {
    let x: Double
    let y: Double
    
    static func from(_ point: CGPoint) -> PiecePosition {
        PiecePosition(x: Double(point.x), y: Double(point.y))
    }
    
    func toCGPoint() -> CGPoint {
        CGPoint(x: x, y: y)
    }
}

// MARK: - PuzzleGame Class
@Observable
class PuzzleGame {
    var puzzlePieceCount: Int
    var showNoPiecesAlert: Bool = false
    var isCompleted: Bool = false
    let puzzleType: PuzzleType
    // 퍼즐 타입별로 고유한 저장소 키 생성
    private var stateKey: String {
        "puzzle_state_\(puzzleType.rawValue)" // 예: puzzle_state_tuna
    }
    
    init(puzzleType: PuzzleType, initialPieceCount: Int = 22) {
        self.puzzleType = puzzleType
        
        if let savedState = Self.loadState(for: puzzleType) {
            self.puzzlePieceCount = savedState.remainingPieces
            self.isCompleted = savedState.completionDate != nil
        } else {
            self.puzzlePieceCount = initialPieceCount
        }
    }
    
    // MARK: - Puzzle Piece Management
    func usePuzzlePiece() -> Bool {
        if puzzlePieceCount > 0 {
            puzzlePieceCount -= 1
            saveCurrentState()
            return true
        } else {
            showNoPiecesAlert = true
            return false
        }
    }
    
    // MARK: - State Management
    // 현재 퍼즐의 상태를 UserDefaults에 저장
    // - Parameter placedPieces: 배치된 퍼즐 조각들의 정보
    private func saveCurrentState(placedPieces: [PlacedPieceInfo] = []) {
        let state = PuzzleState(
            placedPieces: placedPieces,
            completionDate: isCompleted ? Date() : nil,
            remainingPieces: puzzlePieceCount
        )
        
        if let encoded = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(encoded, forKey: stateKey)
        }
    }
    
    static func loadState(for type: PuzzleType) -> PuzzleState? {
        let key = "puzzle_state_\(type.rawValue)"
        guard let data = UserDefaults.standard.data(forKey: key),
              let state = try? JSONDecoder().decode(PuzzleState.self, from: data) else {
            return nil
        }
        return state
    }
    
    // MARK: - Puzzle Progress Management
    func savePuzzleProgress(pieces: [PuzzlePiece]) {
        let placedPiecesInfo = pieces.map { piece in
            PlacedPieceInfo(
                pieceName: puzzleType.getPieceImageName(index: piece.index),  // index 사용
                position: PiecePosition.from(piece.currentPosition),
                isPlaced: piece.isPlaced
            )
        }
        saveCurrentState(placedPieces: placedPiecesInfo)
    }
    
    func getPlacedPiecesInfo() -> [PlacedPieceInfo] {
        return Self.loadState(for: puzzleType)?.placedPieces ?? []
    }
    
    func getPlacedPieces() -> [String] {
        return getPlacedPiecesInfo()
            .filter { $0.isPlaced }
            .map { $0.pieceName }
    }
    
    var completionDate: Date? {
        Self.loadState(for: puzzleType)?.completionDate
    }
    
    // MARK: - Utility Functions
    func getAllPieceNames() -> [String] {
        return (0...23).map { puzzleType.getPieceImageName(index: $0) }
    }
    
    func isPiecePlaced(_ pieceName: String) -> Bool {
        getPlacedPieces().contains(pieceName)
    }
    
    var progress: Double {
        Double(getPlacedPieces().count) / 24.0
    }
    
    // MARK: - Reset Function
    func resetPuzzle() {
        puzzlePieceCount = 22
        isCompleted = false
        UserDefaults.standard.removeObject(forKey: stateKey)
    }
}

// MARK: - PuzzlePiece Structure
struct PuzzlePiece: Identifiable {
    var id = UUID()
    var image: Image
    var correctFrame: CGRect
    var currentPosition: CGPoint
    var isPlaced: Bool = false
    var isSelected: Bool = false
    var index: Int
}
