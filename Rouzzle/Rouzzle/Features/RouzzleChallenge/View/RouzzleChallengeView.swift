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
            
            VStack(alignment: .leading, spacing: 20) {
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
                
                VStack {
                    
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
        }
        .padding(.horizontal, -16)
        .customNavigationBar(title: "루즐 챌린지")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                PieceCounter(count: 9)
            }
        }
    }
}

#Preview {
    NavigationStack {
        RouzzleChallengeView()
    }
}
