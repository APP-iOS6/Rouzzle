//
//  RouzzleChallengeView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/12/24.
//

import SwiftUI

struct RouzzleChallengeView: View {
    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                colors: [.white, Color.fromRGB(r: 252, g: 255, b: 240)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
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
                    .padding(.top, 27)
                    .onTapGesture {
                        print("참여 안내 탭눌림")
                    }
                    
                    // 메인 챌린지
                    ZStack(alignment: .bottomTrailing) {
                        NavigationLink(destination: RouzzleChallengePuzzleView()) {
                            Image(.tuna)
                                .resizable()
                                .frame(maxWidth: .infinity)
                                .aspectRatio(370/278, contentMode: .fit)
                        }
                        
                        RouzzleChallengePlayButton(style: .large) {
                            // 버튼은 시각적 요소로만 사용
                        }
                        .padding([.bottom, .trailing], 16)
                    }
                    .padding(.top, 0)
                    
                    // 퍼즐 이미지 목록
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 24) {
                        let puzzleImages = [
                            ("ned", 1.0), ("chan", 1.0),
                            ("siyeon", 0.3), ("dongbao", 0.3),
                            ("baengho", 0.3), ("yoshi", 0.3),
                            ("gadi", 0.3), ("maple", 0.3)
                        ]
                        
                        ForEach(puzzleImages, id: \.0) { (imageName, opacity) in
                            ZStack(alignment: .bottomTrailing) {
                                if opacity == 1.0 {
                                    NavigationLink(destination: RouzzleChallengePuzzleView()) {
                                        Image(imageName)
                                            .resizable()
                                            .aspectRatio(1, contentMode: .fit)
                                            .frame(width: 173, height: 173)
                                            .opacity(opacity)
                                    }
                                    
                                    RouzzleChallengePlayButton(style: .small) {
                                        // 버튼은 시각적 요소로만 사용
                                    }
                                    .padding([.bottom, .trailing], 8)
                                } else {
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
                }
            }
            .customNavigationBar(title: "루즐 챌린지")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    PieceCounter(count: 9)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RouzzleChallengeView()
    }
}
