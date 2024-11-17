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
                                ForEach(Array(viewModel.userFavorites), id: \.self) { user in
                                    NavigationLink(destination: SocialMarkDetailView(userProfile: user, isStarred: viewModel.judgeFavoriteUsers(userID: user.documentId!))) {
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
                    }
                    
                    VStack(alignment: .leading) {
                        Text("루즐러 둘러보기")
                            .font(.semibold18)
                        
                        // 사용자 랜덤으로 보여주기
                        LazyVStack(spacing: 15) {
                            ForEach(Array(viewModel.userProfiles), id: \.self) { user in
                                if !viewModel.userFavorites.contains(where: { $0.documentId == user.documentId!}) && !user.routines.isEmpty {
                                    if user.documentId != Utils.getUserUUID() {
                                        RoutineCardView(userProfile: user) { id in
                                            viewModel.setSelectedUser(userID: id)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .refreshable {
            await viewModel.addFavoriteUsers()
            await viewModel.fetchUserProfiles()
        }
    }
}

#Preview {
    SocialView()
}
