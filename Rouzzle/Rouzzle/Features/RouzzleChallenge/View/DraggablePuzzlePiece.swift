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
    @State private var debugInfo: String = ""
    
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
        ZStack {
            piece.image
                .resizable()
                .frame(width: piece.correctFrame.width, height: piece.correctFrame.height)
                .position(x: position.x + dragOffset.width, y: position.y + dragOffset.height)
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            state = value.translation
                            _ = position.x + value.translation.width
                            _ = position.y + value.translation.height
                            _ = calculateYPosition(piece)
                        }
                        .onEnded { value in
                            let newPosition = CGPoint(
                                x: position.x + value.translation.width,
                                y: position.y + value.translation.height
                            )
                            
                            let snapDistance = min(screenSize.width * 0.08, 30)
                            let targetX = piece.correctFrame.midX + (screenSize.width - imageSize.width) / 2 + calculateXAdjustment()
                            let targetY = calculateYPosition(piece)
                            
                            print("""
                                    === 퍼즐 조각 위치 정보 ===
                                    📍 목표 위치
                                    X좌표: \(String(format: "%.1f", targetX))
                                    Y좌표: \(String(format: "%.1f", targetY))
                                    
                                    📍 현재 위치
                                    X좌표: \(String(format: "%.1f", newPosition.x))
                                    Y좌표: \(String(format: "%.1f", newPosition.y))
                                    
                                    📏 거리 차이
                                    X좌표 차이: \(String(format: "%.1f", abs(newPosition.x - targetX)))
                                    Y좌표 차이: \(String(format: "%.1f", abs(newPosition.y - targetY)))
                                    
                                    📱 화면 정보
                                    스냅 거리: \(snapDistance)
                                    화면 크기: \(screenSize.width) x \(screenSize.height)
                                    이미지 크기: \(imageSize.width) x \(imageSize.height)
                                    ====================
                                    """)
                            
                            if abs(newPosition.x - targetX) < snapDistance &&
                                abs(newPosition.y - targetY) < snapDistance {
                                var updatedPiece = piece
                                updatedPiece.currentPosition = CGPoint(x: targetX, y: targetY)
                                updatedPiece.isPlaced = true
                                updatedPiece.isSelected = false
                                
                                _ = puzzleGame.usePuzzlePiece()
                                print("✅ 퍼즐 조각이 제자리에 놓였습니다!")
                                
                                onPieceMoved(updatedPiece)
                            } else {
                                position = newPosition
                                var updatedPiece = piece
                                updatedPiece.currentPosition = newPosition
                                onPieceMoved(updatedPiece)
                                print("❌ 퍼즐 조각이 제자리와 너무 멀리 있습니다")
                            }

                        }
                )
            
            Text(debugInfo)
                .font(.system(size: 10))
                .foregroundColor(.black)
                .background(Color.white.opacity(0.8))
                .offset(y: -50)
        }
    }
}
