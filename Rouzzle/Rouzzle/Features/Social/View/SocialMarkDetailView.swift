//
//  SocialMarkDetailView.swift
//  Rouzzle
//
//  Created by 이다영 on 11/11/24.
//

import SwiftUI

struct SocialMarkDetailView: View {
    var userProfile: UserProfile
    @State var isStarred: Bool
    @Environment(SocialViewModel.self) private var viewModel
    @State private var routines: [Routine] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                ProfileCachedImage(frameSize: 50, imageUrl: userProfile.profileImageUrl)

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
                            Task {
                                await viewModel.toggleFavoriteUser(userID: userProfile.documentId!)
                            }
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
                Text(userProfile.introduction ?? "")
                    .font(.regular14)
                    .foregroundColor(.black)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 40, alignment: .topLeading)

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(routines, id: \.self) { routine in
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
        .onAppear {
            Task {
                 await loadRoutines()
             }
            isStarred = viewModel.isUserFavorited(userID: userProfile.documentId!)
        }
        .customNavigationBar(title: userProfile.nickname)
    }
    
    /// Firestore에서 루틴 데이터 로드
    private func loadRoutines() async {
        guard let userId = userProfile.documentId else { return }
        routines = await viewModel.fetchRoutines(for: userId)
    }
}

struct RoutineDetailCardView2: View {
    var routine: Routine
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                RoutineLabelView(text: "\(routine.emoji) \(routine.title)", isSelected: true, onTap: {})
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
