//
//  testView.swift
//  Rouzzle
//
//  Created by 이다영 on 11/11/24.
//

import SwiftUI

struct SocialMarkDetailView2: View {
    var userNickname: String
    
    var body: some View {
        VStack(spacing: 16) {
            // 사용자 정보
            HStack(alignment: .top) {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(userNickname)
                            .font(.title3).bold()
                        Text("루즐러")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                    
                    HStack(spacing: 8) {
                        Label("루틴 10일차", systemImage: "leaf.circle")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Label("연속 성공 5일차", systemImage: "flame.fill")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                    }
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.title)
                }
            }
            .padding(.horizontal)
            
            Text("메이플의 짱이 되는 그날까지 ...")
                .font(.body)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // 루틴 카드
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(0..<2) { _ in
                        RoutineDetailCardView()
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(userNickname)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    // 뒤로 가기
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.green)
                }
            }
        }
    }
}

struct RoutineDetailCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                RoutineLabelView(text: "저녁 루틴")
                Spacer()
                Text("8:30 AM ~ 8:50 AM")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(DummyTask.tasks) { task in
                    HStack {
                        Text(task.emoji)
                        Text(task.title)
                            .font(.body)
                        Spacer()
                        if let timer = task.timer {
                            Text("\(timer / 60)분") // 분 단위로 표시
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .padding(.vertical, 4)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// 테스트용 미리보기
#Preview {
    SocialMarkDetailView2(userNickname: "메어른")
}
