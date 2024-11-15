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
    
    var body: some View {
        VStack(spacing: 0) {
            // Info Box
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .frame(width: UIScreen.main.bounds.width - 32)
                .frame(height: 130)
                .overlay(
                    HStack(spacing: 15) {
                        VStack(spacing: 8) {
                            Text("🧩")
                                .font(.system(size: 32))
                            Text("\(solvedPuzzles)개")
                                .font(.bold24)
                            Text("맞춘 퍼즐")
                                .font(.regular12)
                        }
                        .frame(maxWidth: .infinity)
                        
                        DashedDivider()
                            .frame(height: 93)
                        
                        VStack(spacing: 8) {
                            Text("🔥")
                                .font(.system(size: 32))
                            Text("\(consecutiveDays)일")
                                .font(.bold24)
                            Text("연속일")
                                .font(.regular12)
                        }
                        .frame(maxWidth: .infinity)
                        
                        DashedDivider()
                            .frame(height: 93)
                        
                        VStack(spacing: 8) {
                            Text("🗓️")
                                .font(.system(size: 32))
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
            
            // 배지 Box
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 64)
                .overlay(
                    HStack {
                        Text("획득 가능 배지")
                            .font(.medium14)
                        
                        Spacer()
                        
                        Image("temporarybadge")
                    }
                    .padding(.horizontal)
                )
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 0)
                .padding(.top, 20)
        }
        .padding(.top, 20)
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
