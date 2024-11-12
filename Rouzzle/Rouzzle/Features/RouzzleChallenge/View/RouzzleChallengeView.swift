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
                    
                    // 메인 챌린지 이미지
                    Image(.tuna)
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .aspectRatio(370/278, contentMode: .fit)
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
                            Image(imageName)
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .frame(width: 173, height: 173)
                                .opacity(opacity)
                                .onTapGesture {
                                    if opacity == 1.0 {
                                        print("\(imageName) 퍼즐 선택됨")
                                    } else {
                                        print("\(imageName) 잠금 상태")
                                    }
                                }
                        }
                    }
                    .padding(.vertical, 40)
                    
                    Text("새로운 퍼즐이 곧 업데이트될 예정입니다.\n많이 기대해 주세요! 😆")
                        .font(.regular16)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 100)
                        .frame(maxWidth: .infinity, alignment: .center)
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
