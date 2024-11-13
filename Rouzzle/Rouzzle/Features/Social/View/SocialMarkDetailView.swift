//
//  SocialMarkDetailView.swift
//  Rouzzle
//
//  Created by 이다영 on 11/11/24.
//

import SwiftUI

struct SocialMarkDetailView: View {
    var userProfile: UserProfile
    @State private var isStarred: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                
                AsyncImage(url: URL(string: userProfile.profileImageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(userProfile.nickname)
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
                    ForEach(userProfile.routines, id: \.self) { routine in
                        if !routine.routineTask.isEmpty {
                            RoutineDetailCardView2(routine: routine) // 각 할 일 목록 카드
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                    )
                }
            }
        }
        .customNavigationBar(title: userProfile.nickname)
    }
}

struct RoutineDetailCardView2: View {
    var routine: Routine
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                RoutineLabelView(text: "\(routine.emoji) \(routine.title)")
                Spacer()
                Text("8:30 AM ~ 8:50 AM")
                    .font(.light12)
                    .foregroundColor(.gray)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(routine.routineTask, id: \.self) { task in
                    
                    HStack(spacing: 2) {
                        Text(task.emoji)
                        Text(task.title)
                            .font(.regular12)
                            .padding(.leading, 4)
                        Spacer()
                        
                        Text("\(task.timer / 60)분")
                            .font(.regular12)
                            .foregroundColor(.gray)
                        
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
