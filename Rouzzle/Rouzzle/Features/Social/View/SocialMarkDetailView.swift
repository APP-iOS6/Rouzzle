//
//  SocialMarkDetailView.swift
//  Rouzzle
//
//  Created by 이다영 on 11/11/24.
//

import SwiftUI

struct SocialMarkDetailView: View {
    var userNickname: String
    @State private var isStarred: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                // 프로필 이미지
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(userNickname)
                            .font(.bold16)
                        Text("루즐러")
                            .font(.regular14)
                            .foregroundColor(.accent)
                        Spacer()
                        
                        Button(action: {
                            isStarred.toggle()
                        }, label: {
                            Image(systemName: isStarred ? "star.fill" : "star")
                                .foregroundColor(isStarred ? .yellow : .gray)
                        })
                    }
                    
                    HStack {
                        Text("🧩 루틴 10일차")
                        Text("🔥 연속 성공 5일차")
                    }
                    .font(.regular12)
                    .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding(.top, 40)
            
            VStack(alignment: .leading) {
                Text("자기소개")
                    .font(.regular14)
                    .foregroundColor(.black)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 40, alignment: .topLeading)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(0..<2) { _ in
                        RoutineDetailCardView2() // 각 할 일 목록 카드
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                    )
                }
            }
        }
        .customNavigationBar(title: userNickname)
    }
}

struct RoutineDetailCardView2: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                RoutineLabelView(text: "저녁 루틴")
                Spacer()
                Text("8:30 AM ~ 8:50 AM")
                    .font(.light12)
                    .foregroundColor(.gray)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(DummyTask.tasks) { task in
                    HStack(spacing: 2) {
                        Text(task.emoji)
                        Text(task.title)
                            .font(.regular12)
                            .padding(.leading, 4)
                        Spacer()
                        if let timer = task.timer {
                            Text("\(timer / 60)분")
                                .font(.regular12)
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

#Preview {
    SocialMarkDetailView(userNickname: "기바오")
}
