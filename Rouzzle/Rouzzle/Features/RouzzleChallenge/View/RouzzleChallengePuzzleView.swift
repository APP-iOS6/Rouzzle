//
//  RouzzleChallengePuzzleView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/15/24.
//

import SwiftUI

struct RouzzleChallengePuzzleView: View {
    let puzzleGame: PuzzleGame
    @State private var solvedPuzzles: Int = 0
    @State private var consecutiveDays: Int = 0
    
    init(puzzleGame: PuzzleGame) {
        self.puzzleGame = puzzleGame
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenSize = geometry.size
            let horizontalPadding: CGFloat = 16
            let imageWidth = min((screenSize.width - (horizontalPadding * 2)), 370)
            let imageHeight = imageWidth * (278/370)
            
            ZStack(alignment: .top) {
                PuzzleView(
                    puzzleGame: puzzleGame,
                    imageSize: CGSize(width: imageWidth, height: imageHeight),
                    screenSize: screenSize
                )
                
                VStack {
                    PuzzleInfoBox(solvedPuzzles: solvedPuzzles, consecutiveDays: consecutiveDays)
                    Spacer()
                }
            }
        }
        .padding(.horizontal, -16)
        .customNavigationBar(title: "루즐 퍼즐테스트")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                PieceCounter(count: puzzleGame.puzzlePieceCount)
            }
        }
        .hideTabBar(true)
    }
}
