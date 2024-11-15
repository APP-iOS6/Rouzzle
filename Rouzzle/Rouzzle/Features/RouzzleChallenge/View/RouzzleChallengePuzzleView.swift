//
//  RouzzleChallengePuzzleView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/15/24.
//

import SwiftUI

struct RouzzleChallengePuzzleView: View {
    let puzzleGame: PuzzleGame
    
    init(puzzleGame: PuzzleGame) {
        self.puzzleGame = puzzleGame
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenSize = geometry.size
            let imageWidth = min(screenSize.width * 0.9, 370)  // 최대 너비 제한
            let imageHeight = imageWidth * (278/370)  // 원본 비율 유지
            
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                
                PuzzleView(
                    puzzleGame: puzzleGame,
                    imageSize: CGSize(width: imageWidth, height: imageHeight),
                    screenSize: screenSize
                )
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
