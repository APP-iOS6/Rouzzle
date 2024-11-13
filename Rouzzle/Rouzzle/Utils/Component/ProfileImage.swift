//
//  ProfileImage.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/12/24.
//

import SwiftUI

struct ProfileImageView: View {
    var frameSize: CGFloat
    var profileImage: UIImage?
    
    var body: some View {
        Group {
            if let profileImage = profileImage {
                // 프로필 사진이 있으면 표시
                Image(uiImage: profileImage)
                    .resizable()
            } else {
                Image(.defaultProfile)
                    .resizable()
                    .scaleEffect(0.5)
            }
        }
        .scaledToFill()
        .frame(width: frameSize, height: frameSize)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(Color.accentColor, lineWidth: 2)
        )
    }
}

#Preview {
    ProfileImageView(frameSize: 73)
}
