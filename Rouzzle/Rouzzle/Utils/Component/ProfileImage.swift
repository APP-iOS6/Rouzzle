//
//  ProfileImage.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/12/24.
//

import SwiftUI

// 기본 프사
struct EmptyProfileView: View {
    var frameSize: CGFloat
    var userInfo = RoutineUser(name: "", profileUrlString: "", introduction: "")

    var body: some View {
        Image(systemName: "person.fill")
            .resizable()
            .scaledToFit()
            .foregroundStyle(.accent)
            .frame(width: frameSize, height: frameSize)
            .scaleEffect(0.6)
            .background(
                Circle()
                    .fill(.white)
                    .stroke(.accent, lineWidth: 2)
            )
    }
}

// 사용자가 이미지 넣었을 때 뜨는 프사
struct ProfileImageView: View {
    var frameSize: CGFloat
    var profileImage: UIImage?
    
    private let defaultProfileImageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/rouzzle-e4c69.firebasestorage.app/o/UserProfile%2FProfile.png?alt=media&token=94dc34d2-e7dd-4518-bd23-9c7866cfda2e")
    
    var body: some View {
        Group {
            if let profileImage = profileImage {
                // 프로필 사진이 있으면 표시
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFill()
            } else if let url = defaultProfileImageUrl,
                      let imageData = try? Data(contentsOf: url),
                      let defaultImage = UIImage(data: imageData) {
                // 프로필 사진이 없을 경우 기본 이미지 로드
                Image(uiImage: defaultImage)
                    .resizable()
                    .scaledToFill()
            } else {
                // 기본 이미지 로드가 실패했을 때 빈 뷰
                EmptyProfileView(frameSize: frameSize)
            }
        }
        .overlay(
            Circle()
                .stroke(.accent, lineWidth: 2)
        )
        .frame(width: frameSize, height: frameSize)
        .clipShape(Circle())
    }
}

#Preview {
    EmptyProfileView(frameSize: 73)
}
