//
//  PuzzleInfoBox.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/15/24.
//

import SwiftUI

struct PuzzleInfoBox: View {
    let solvedPuzzles: Int
    let consecutiveDays: Int
    let remainingDays: Int = 30
    
    private var isSE: Bool {
           let screenWidth = UIScreen.main.bounds.width
           let screenHeight = UIScreen.main.bounds.height
           return (Int(screenWidth), Int(screenHeight)) == (375, 667)
       }
    
    var body: some View {
        GeometryReader { _ in
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            
            let scale: CGFloat = {
                switch (Int(screenWidth), Int(screenHeight)) {
                case (375, 667): return 0.8  // iPhone SE
                case (375, 690): return 0.95
                default:
                    switch Int(screenWidth) {
                    case 440: return 1.2
                    case 430, 428: return 1.15
                    case 414: return 1.1
                    case 402: return 1.1
                    case 393: return 1
                    case 390: return 1
                    case 375: return 0.95
                    default: return 1
                    }
                }
            }()
            
            let boxHeight = 130 * scale
            let badgeHeight = 64 * scale
            let padding = 20 * scale
            let emojiSize = 32 * scale
            let dividerHeight = 93 * scale
            let topPadding: CGFloat = isSE ? 10 : 20 * scale
            
            VStack(spacing: 0) {
                // Info Box
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .frame(width: screenWidth - 32)
                    .frame(height: boxHeight)
                    .overlay(
                        HStack(spacing: 15) {
                            VStack(spacing: 8) {
                                Text("🧩")
                                    .font(.system(size: emojiSize))
                                Text("\(solvedPuzzles)개")
                                    .font(.bold24)
                                Text("맞춘 퍼즐")
                                    .font(.regular12)
                            }
                            .frame(maxWidth: .infinity)
                            
                            DashedDivider()
                                .frame(height: dividerHeight)
                            
                            VStack(spacing: 8) {
                                Text("🔥")
                                    .font(.system(size: emojiSize))
                                Text("\(consecutiveDays)일")
                                    .font(.bold24)
                                Text("연속일")
                                    .font(.regular12)
                            }
                            .frame(maxWidth: .infinity)
                            
                            DashedDivider()
                                .frame(height: dividerHeight)
                            
                            VStack(spacing: 8) {
                                Text("🗓️")
                                    .font(.system(size: emojiSize))
                                Text("\(remainingDays)일")
                                    .font(.bold24)
                                Text("남은 기간")
                                    .font(.regular12)
                            }
                            .frame(maxWidth: .infinity)
                        }
                            .padding(.horizontal)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 0)
                
                // Badge Box
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .frame(width: screenWidth - 32, height: badgeHeight)
                    .overlay(
                        HStack {
                            Text("획득 가능 배지")
                                .font(.medium14)
                            
                            Spacer()
                            
                            Image("temporarybadge")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: badgeHeight * 0.5)
                        }
                            .padding(.horizontal)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 0)
                    .padding(.top, padding)
            }
            .padding(.top, topPadding)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: isSE ? 200 : 250)
    }
    
    struct DashedDivider: View {
        var body: some View {
            VStack {
                ForEach(0..<9) { _ in
                    Rectangle()
                        .fill(Color.graylight)
                        .frame(width: 1.5, height: 2)
                        .padding(.vertical, 0.1)
                }
            }
            .frame(width: 1)
        }
    }
}
