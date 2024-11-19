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
                    }
                    
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
                                                ProfileCachedImage(imageUrl: user.profileImageUrl)
                                                    .frame(width: 60, height: 60)
                                                    .clipShape(Circle())
                                                Text(user.nickname)
                                                    .font(.regular12)
                                                    .foregroundColor(.black)
                                            }
                                        }
                                    }
                                }
                            }
                        }                    }
                    
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
                                        isStarred: viewModel.isUserFavorited(userID: user.documentId ?? ""), userProfile: user,
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
