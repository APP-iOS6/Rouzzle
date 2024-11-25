//
//  RouzzleChallengePuzzleView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/15/24.
//

import SwiftUI

struct RouzzleChallengePuzzleView: View {
    let puzzleGame: PuzzleGame
    @Environment(RoutineStore.self) private var routineStore
    @State private var solvedPuzzles: Int = 0
    @State private var consecutiveDays: Int = 0
    
    init(puzzleGame: PuzzleGame) {
        self.puzzleGame = puzzleGame
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenSize = geometry.size
            let horizontalPadding: CGFloat = 16
            let scale: CGFloat = {
                switch (screenSize.width, screenSize.height) {
                case (440, 821...822): // iPhone 16 Pro Max
                    return 1.0
                case (430, 800...801): // iPhone 14 Pro Max, iPhone 15 Plus
                    return 1.0
                case (428, 801): // iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus
                    return 1.0
                case (414, 770...774): // iPhone XR, XS Max, 11, 11 Pro Max
                    return 1.0
                case (375, 603): // iPhone SE
                    return 1.0
                default:
                    return 1.0
                }
            }()
            let baseWidth = screenSize.width - (horizontalPadding * 2)
            let imageWidth = baseWidth * scale
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
        .customNavigationBar(title: "루즐 챌린지")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                PieceCounter(
                    count: routineStore.myPuzzle,
                    phase: routineStore.puzzlePhase
                ) {
                    routineStore.fetchMyData()
                }
            }
        }       .hideTabBar(true)
    }
}
