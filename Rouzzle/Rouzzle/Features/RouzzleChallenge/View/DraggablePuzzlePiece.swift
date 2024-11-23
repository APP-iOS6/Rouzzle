//
//  DraggablePuzzlePiece.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/15/24.
//

import SwiftUI

struct DraggablePuzzlePiece: View {
    let piece: PuzzlePiece
    @Binding var pieces: [PuzzlePiece]
    let puzzleGame: PuzzleGame
    let imageSize: CGSize
    let screenSize: CGSize
    let calculateYPosition: (PuzzlePiece) -> CGFloat
    let calculateXAdjustment: () -> CGFloat
    let onPieceMoved: (PuzzlePiece) -> Void
    
    @State private var position: CGPoint
    @GestureState private var dragOffset = CGSize.zero
    
    init(piece: PuzzlePiece,
         pieces: Binding<[PuzzlePiece]>,
         puzzleGame: PuzzleGame,
         imageSize: CGSize,
         screenSize: CGSize,
         calculateYPosition: @escaping (PuzzlePiece) -> CGFloat,
         calculateXAdjustment: @escaping () -> CGFloat,
         onPieceMoved: @escaping (PuzzlePiece) -> Void) {
        self.piece = piece
        self._pieces = pieces
        self.puzzleGame = puzzleGame
        self.imageSize = imageSize
        self.screenSize = screenSize
        self.calculateYPosition = calculateYPosition
        self.calculateXAdjustment = calculateXAdjustment
        self.onPieceMoved = onPieceMoved
        self._position = State(initialValue: piece.currentPosition)
    }
    
    var body: some View {
        piece.image
            .resizable()
            .frame(width: piece.correctFrame.width, height: piece.correctFrame.height)
            .position(x: position.x + dragOffset.width, y: position.y + dragOffset.height)
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation
                    }
                    .onEnded { value in
                        let newPosition = CGPoint(
                            x: position.x + value.translation.width,
                            y: position.y + value.translation.height
                        )
                        
                        let snapDistance = min(screenSize.width * 0.08, 30)
                        let targetX = piece.correctFrame.midX + (screenSize.width - imageSize.width) / 2 + calculateXAdjustment()
                        let targetY = calculateYPosition(piece)
                        
                        if abs(newPosition.x - targetX) < snapDistance &&
                            abs(newPosition.y - targetY) < snapDistance {
                            var updatedPiece = piece
                            updatedPiece.currentPosition = CGPoint(x: targetX, y: targetY)
                            updatedPiece.isPlaced = true
                            updatedPiece.isSelected = false
                            
                            if puzzleGame.usePuzzlePiece() {
                                position = CGPoint(x: targetX, y: targetY)
                                onPieceMoved(updatedPiece)
                                // 조각을 놓을 때마다 전체 상태 저장
                                puzzleGame.savePuzzleProgress(pieces: pieces)
                            }
                        } else {
                            position = newPosition
                            var updatedPiece = piece
                            updatedPiece.currentPosition = newPosition
                            onPieceMoved(updatedPiece)
                        }
                    }
            )
    }
}
