//
//  SocialView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import SwiftUI

struct SocialView: View {
    @State private var viewModel: SocialViewModel = SocialViewModel()
    @State private var query: String = ""
    @State private var expandedRoutineIndex: Int?

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 40) {
                VStack {
                    HStack {
                        Text("소셜")
                            .font(.semibold18)
                            .foregroundStyle(.basic)
                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    SearchBarView(text: $query)
                        .animation(.easeInOut, value: query)
                }
                
                VStack(alignment: .leading) {
                    Text("즐겨찾기")
                        .font(.semibold18)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.userProfiles) { user in
                                NavigationLink(destination: SocialMarkDetailView(userProfile: user)) {
                                    VStack {
                                        AsyncImage(url: URL(string: user.profileImageUrl)) { image in
                                            image
                                                .resizable()
                                                .frame(width: 60, height: 60)
                                                .clipShape(Circle())
                                        } placeholder: {
                                            ProgressView()
                                                .frame(width: 60, height: 60)
                                                .clipShape(Circle())
                                        }
                                        Text(user.nickname)
                                            .font(.regular12)
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("루즐러 둘러보기")
                        .font(.semibold18)
                    
                    // 사용자 랜덤으로 보여주기
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(0..<3) { index in
                                RoutineCardView(isExpanded: expandedRoutineIndex == index, onToggleExpand: {
                                    withAnimation {
                                        expandedRoutineIndex = (expandedRoutineIndex == index) ? nil : index
                                    }
                                }, tasks: DummyTask.tasks)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            Task {
                await viewModel.fetchUserProfiles()
            }
        }
    }
}

struct RoutineCardView: View {
    var isExpanded: Bool
    var onToggleExpand: () -> Void
    @State private var isStarred: Bool = false
    var tasks: [DummyTask]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 15) {
                // 프로필 이미지
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        // 닉네임
                        Text("메어른")
                            .font(.semibold16)
                        
                        // 연속일
                        Text("23일")
                            .font(.regular12)
                            .foregroundColor(.red)
                            .padding(.leading, 3)
                        Text("째 루틴 중")
                            .font(.regular12)
                            .foregroundColor(.gray)
                            .offset(x: -7)
                    }
                    // 자기소개
                    Text("메이플의 짱이 되는 그날까지 ...")
                        .font(.regular12)
                        .lineLimit(isExpanded ? nil : 1)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // 즐겨찾기
                Button(action: {
                    isStarred.toggle()
                }, label: {
                    Image(systemName: isStarred ? "star.fill" : "star")
                        .foregroundColor(isStarred ? .yellow : .gray)
                })
            }
            
            HStack {
                // 루틴이름
                RoutineLabelView(text: "아침 루틴")
                
                Spacer()
                
                // 더보기 버튼
                Button(action: {
                    onToggleExpand()
                }, label: {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                })
            }
            .padding(.top, 3)
            
            if isExpanded {
                //                Divider()
                RoutineTasksView(tasks: tasks)
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// 더보기(루틴 할 일 리스트)
struct RoutineTasksView: View {
    var tasks: [DummyTask]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("8:30 AM - 8:50 AM")
                .font(.light12)
                .foregroundColor(.gray)
            
            ForEach(tasks) { task in
                HStack(spacing: 2) {
                    Text(task.emoji)
                    Text(task.title)
                        .font(.regular12)
                        .padding(.leading, 4)
                    Spacer()
                    if let timer = task.timer {
                        Text("\(timer/60)분")
                            .font(.regular12)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

#Preview {
    SocialView()
}
