//
//  SocialView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import SwiftUI

struct SocialView: View {
    @Environment(SocialViewModel.self) private var viewModel
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
                            .onChange(of: query) { _, newQuery in
                                viewModel.performSearch(query: newQuery)
                            }
                        
                        // 검색 결과
                        if query.isEmpty {
                            // 기존 뷰 상태
                            VStack(alignment: .leading) {
                                Text("즐겨찾기")
                                    .font(.semibold18)
                                
                                if viewModel.userFavorites.isEmpty {
                                    Text("즐겨찾기한 사용자가 없습니다.")
                                        .font(.regular14)
                                        .foregroundColor(.gray)
                                        .padding(.vertical)
                                } else {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 15) {
                                            ForEach(Array(viewModel.userFavorites), id: \.self) { user in
                                                NavigationLink(destination: SocialMarkDetailView(userProfile: user, isStarred: true)) {
                                                    VStack {
                                                        ProfileCachedImage(frameSize: 60, imageUrl: user.profileImageUrl)
                                                        Text(user.nickname)
                                                            .font(.regular12)
                                                            .foregroundColor(.black)
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.leading, 5)
                                        .padding(.top, 5)
                                    }
                                }
                            }
                            .padding(.top, 20)
                            
                            VStack(alignment: .leading) {
                                Text("루즐러 둘러보기")
                                    .font(.semibold18)
                                
                                if viewModel.otherUserProfiles.isEmpty {
                                    Text("표시할 사용자가 없습니다.")
                                        .font(.regular14)
                                        .foregroundColor(.gray)
                                } else {
                                    LazyVStack(spacing: 15) {
                                        ForEach(Array(viewModel.otherUserProfiles).filter { user in
                                            !viewModel.isUserFavorited(userID: user.documentId ?? "")
                                        }, id: \.self) { user in
                                            RoutineCardView(
                                                userProfile: user,
                                                action: { id in
                                                    Task {
                                                        await viewModel.toggleFavoriteUser(userID: id)
                                                    }
                                                }
                                            )
                                        }
                                    }
                                }
                            }
                            .padding(.top, 20)
                        } else if !viewModel.searchResults.isEmpty {
                            // 검색 리스트
                            VStack(alignment: .leading) {
                                ForEach(viewModel.searchResults, id: \.id) { user in
                                    NavigationLink {
                                        SocialMarkDetailView(userProfile: UserProfile(
                                            documentId: user.id,
                                            nickname: user.name,
                                            profileImageUrl: user.profileUrlString,
                                            introduction: user.introduction,
                                            routines: []
                                        ), isStarred: false)
                                    } label: {
                                        HStack {
                                            ProfileCachedImage(frameSize: 44, imageUrl: user.profileUrlString)

                                            Text(user.name)
                                                .font(.semibold16)
                                                .foregroundStyle(.black)
                                            
                                            Text(user.introduction)
                                                .foregroundStyle(.gray)
                                                .font(.regular12)
                                        }
                                    }
                                }
                            }
                            .padding(.top, 20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Text("검색 결과가 없습니다.")
                                .font(.light16)
                                .foregroundStyle(.gray)
                                .padding(.top, 20)
                        }
                    }
                }
                .padding()
            }
        }
        .refreshable {
            await viewModel.fetchUserProfiles()
        }
    }
}

#Preview {
    SocialView()
}
