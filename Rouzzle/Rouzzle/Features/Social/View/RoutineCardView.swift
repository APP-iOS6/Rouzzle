//
//  RoutineCardView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/15/24.
//

import SwiftUI

struct RoutineCardView: View {
    @State var isExpanded: Bool = false
    @State var isStarred: Bool
    @State private var selectedRoutineIndex: Int?
    var userProfile: UserProfile
    let action: (String) -> Void

    var body: some View {
        NavigationLink(destination: SocialMarkDetailView(userProfile: userProfile, isStarred: isStarred)) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top, spacing: 15) {
                    // 프로필 이미지
                    ProfileCachedImage(imageUrl: userProfile.profileImageUrl)
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
                        if let introduction = userProfile.introduction {
                            Text(introduction)
                                .font(.regular12)
                                .lineLimit(isExpanded ? nil : 1)
                                .foregroundColor(.gray)
                        }
                    }

                    Spacer()

                    // 즐겨찾기
                    Button(action: {
                        isStarred.toggle()
                        action(userProfile.documentId!)
                    }, label: {
                        Image(systemName: isStarred ? "star.fill" : "star")
                            .foregroundColor(isStarred ? .yellow : .gray)
                    })
                    .buttonStyle(BorderlessButtonStyle()) // 버튼 스타일 수정
                }

                HStack {
                    ScrollView(.horizontal, showsIndicators: false) {
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
                        .padding(2)
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
        .buttonStyle(PlainButtonStyle()) // 기본 버튼 스타일 제거
    }
}
