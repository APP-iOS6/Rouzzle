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
        NavigationStack {
            ScrollView {
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
                                ForEach(viewModel.userProfiles) { user in
                                    RoutineCardView(userProfile: user)
                                }
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
    @State var isExpanded: Bool = false
    @State private var isStarred: Bool = false
    @State private var selectedRoutineIndex: Int?
    var userProfile: UserProfile

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 15) {
                // 프로필 이미지
                AsyncImage(url: URL(string: userProfile.profileImageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 44, height: 44)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        // 닉네임
                        Text("\(userProfile.nickname)")
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
                LazyHStack {
                    ForEach(Array(userProfile.routines.enumerated()), id: \.element.self) { index, routine in
                        RoutineLabelView(
                            text: routine.title,
                            isSelected: selectedRoutineIndex == index,
                            onTap: {
                                withAnimation(.easeInOut) {
                                    if selectedRoutineIndex == index {
                                        selectedRoutineIndex = nil
                                    } else {
                                        selectedRoutineIndex = index
                                    }
                                }
                            }
                        )
                    }
                }
                Spacer()
                
                // 더보기 버튼 (선택된 루틴이 있을 때만 작동)
                Button {
                    withAnimation(.easeInOut) {
                        if selectedRoutineIndex != nil {
                            // 선택된 루틴이 있으면 선택 해제
                            selectedRoutineIndex = nil
                        } else {
                            // 선택된 루틴이 없으면 첫 번째 루틴 선택
                            selectedRoutineIndex = 0
                        }
                    }
                } label: {
                    Image(systemName: selectedRoutineIndex != nil ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(selectedRoutineIndex != nil ? 180 : 0))
                        .animation(.easeInOut, value: selectedRoutineIndex != nil)
                }
            }
            .padding(.top, 2)

            // 선택된 루틴의 세부 정보 표시
            if let selectedIndex = selectedRoutineIndex, selectedIndex < userProfile.routines.count {
                RoutineTasksView(tasks: userProfile.routines[selectedIndex].routineTask)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// 더보기(루틴 할 일 리스트)
struct RoutineTasksView: View {
    var tasks: [RoutineTask]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("8:30 AM - 8:50 AM")
                .font(.light12)
                .foregroundColor(.gray)
            
            ForEach(tasks, id: \.self) { task in
                HStack(spacing: 2) {
                    Text(task.emoji)
                    Text(task.title)
                        .font(.regular12)
                        .padding(.leading, 4)
                    Spacer()
                    Text("\(task.timer/60)분")
                        .font(.regular12)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

#Preview {
    SocialView()
}
