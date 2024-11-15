//
//  RouzzleChallengeView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/12/24.
//

import SwiftUI

struct RouzzleChallengeView: View {
    @State private var selectedPuzzleType: PuzzleType?
    @State private var showPuzzle: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                colors: [.white, Color.fromRGB(r: 252, g: 255, b: 240)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 15) {
                    // 참여 안내
                    HStack(spacing: 5) {
                        Image(systemName: "info.circle")
                            .font(.light12)
                            .foregroundStyle(.gray)
                        
                        Text("참여 안내")
                            .font(.regular12)
                            .underline()
                            .foregroundStyle(.gray)
                    }
                    .padding(.top, 20)
                    .onTapGesture {
                        print("참여 안내 탭눌림")
                    }
                    
                    // 메인 챌린지
                    Button {
                        selectedPuzzleType = .tuna
                        showPuzzle = true
                    } label: {
                        ZStack(alignment: .bottomTrailing) {
                            Image(.tuna)
                                .resizable()
                                .frame(maxWidth: .infinity)
                                .aspectRatio(370/278, contentMode: .fit)
                            
                            RouzzleChallengePlayButton(style: .large)
                                .padding([.bottom, .trailing], 16)
                        }
                    }
                    .padding(.top, 0)
                    
                    // 퍼즐 이미지 목록
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 24) {
                        let puzzleImages = [
                            ("ned", 1.0, PuzzleType.ned),
                            ("chan", 1.0, PuzzleType.chan),
                            ("siyeon", 0.3, nil),
                            ("dongbao", 0.3, nil),
                            ("baengho", 0.3, nil),
                            ("yoshi", 0.3, nil),
                            ("gadi", 0.3, nil),
                            ("maple", 0.3, nil)
                        ]
                        
                        ForEach(puzzleImages, id: \.0) { (imageName, opacity, puzzleType) in
                            if let puzzleType = puzzleType {
                                Button {
                                    selectedPuzzleType = puzzleType
                                    showPuzzle = true
                                } label: {
                                    ZStack(alignment: .bottomTrailing) {
                                        Image(imageName)
                                            .resizable()
                                            .aspectRatio(1, contentMode: .fit)
                                            .frame(width: 173, height: 173)
                                            .opacity(opacity)
                                        
                                        RouzzleChallengePlayButton(style: .small)
                                            .padding([.bottom, .trailing], 8)
                                    }
                                }
                            } else {
                                ZStack(alignment: .bottomTrailing) {
                                    Image(imageName)
                                        .resizable()
                                        .aspectRatio(1, contentMode: .fit)
                                        .frame(width: 173, height: 173)
                                        .opacity(opacity)
                                    
                                    PuzzleLockButton()
                                        .padding([.bottom, .trailing], 8)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 30)
                    
                    Text("새로운 퍼즐이 곧 업데이트될 예정입니다.\n많이 기대해 주세요! 😆")
                        .font(.regular16)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 200)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationDestination(isPresented: $showPuzzle) {
                if let puzzleType = selectedPuzzleType {
                    let game = PuzzleGame(puzzleType: puzzleType)
                    RouzzleChallengePuzzleView(puzzleGame: game)
                }
            }
            .customNavigationBar(title: "루즐 챌린지")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    PieceCounter(count: 9)
                }
            }
        }
        .hideTabBar(true)
    }
}
