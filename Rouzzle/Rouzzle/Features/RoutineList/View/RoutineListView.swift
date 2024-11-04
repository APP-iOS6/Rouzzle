//
//  RoutineListView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import SwiftUI

struct RoutineListView: View {
    var body: some View {
        VStack {
            HStack {
                Label {
                    Text("0")
                        .font(.regular16)
                        .foregroundColor(.black) // 텍스트를 검정색으로 설정
                } icon: {
                    Image(systemName: "puzzlepiece.fill")
                        .foregroundStyle(.button) // 아이콘에 버튼 색상 적용
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: Color.gray.opacity(0.3), radius: 1)
                )
                Spacer()
                Button(action: {}) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundStyle(.button)
                }
                
                
                
            }
            .padding()
            
            Text("끊임없이 남탓하고, 사고하지 말라")
                .font(.bold18)
            
            ZStack {
                Image(.dailyChallenge)
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .aspectRatio(contentMode: .fit)
                Text("24일 루즐 챌린지")
                    .font(.semibold18)
                    .offset(y: -7)
            }
            .padding()
            
            Spacer()
           // Text("Hello, World!")
        }
    }
}

#Preview {
    RoutineListView()
}
