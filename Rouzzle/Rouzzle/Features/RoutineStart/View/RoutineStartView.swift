//
//  RoutineStartView.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/5/24.
//

import SwiftUI

struct RoutineStartView: View {
    var body: some View {
        ZStack(alignment: .top) {
            // MARK: 배경(그라데이션 + 흰색 RoundedRectangle)
            LinearGradient(colors: [.white, Color.fromRGB(r: 204, g: 238, b: 126)],
                           startPoint: .top,
                           endPoint: .center)
            .ignoresSafeArea(edges: .top)
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.white)
                .frame(height: UIScreen.main.bounds.height * 0.6)
                .offset(y: UIScreen.main.bounds.height * 0.5)
                .ignoresSafeArea(edges: .bottom)
            
            VStack(spacing: 0) {
                Text("💊 유산균 먹기")
                    .font(.bold24)
                
                Text("5분")
                    .font(.regular14)
                    .foregroundStyle(Color.fromRGB(r: 153, g: 153, b: 153)) // #999999
                    .padding(.top, 19)
                
                // MARK: 퍼즐 모양 타이머
                ZStack {
                    Image(.puzzleTimer)
                    
                    Text("4:39")
                        .font(.bold54)
                }
                .padding(.top, 31)
                
                // MARK: 버튼 3개(일시정지, 체크, 건너뛰기)
                HStack(spacing: 0) {
                    Button {
                        // 타이머 일시정지
                    } label: {
                        Image(systemName: "pause.circle.fill")
                            .font(.bold50)
                            .foregroundStyle(Color.fromRGB(r: 193, g: 235, b: 96))
                            .background(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65)
                            )
                    }
                    
                    Button {
                        // 할일 완료 로직
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.bold80)
                            .foregroundStyle(Color.fromRGB(r: 193, g: 235, b: 96))
                            .background(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 100, height: 100)
                            )
                    }
                    
                    Button {
                        // 건너뛰기 로직
                    } label: {
                        Image(systemName: "forward.end.circle.fill")
                            .font(.bold50)
                            .foregroundStyle(Color.fromRGB(r: 193, g: 235, b: 96))
                            .background(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65)
                            )
                    }
                }
                .padding(.top, 47)
                
                // MARK: 할일 리스트
                ScrollView {
                    Image(.routine) // 임시로 넣어둠
                    
                    Image(.routine) // 임시로 넣어둠
                }
                .padding(.top, 7)
            }
        }
        .padding(.horizontal, -16)
        .customNavigationBar(title: "")
    }
}

#Preview {
    NavigationStack {
        RoutineStartView()
    }
}
