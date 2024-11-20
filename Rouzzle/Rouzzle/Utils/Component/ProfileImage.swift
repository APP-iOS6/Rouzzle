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
        if let profileImage = profileImage {
            // 프로필 사진이 있으면 표시
            Image(uiImage: profileImage)
                .resizable()
                .frame(width: frameSize, height: frameSize)
                .scaledToFill()
                .clipShape(Circle())
        } else {
            Image(.defaultProfile)
                .resizable()
                .scaleEffect(0.5)
                .frame(width: frameSize, height: frameSize)
                .scaledToFill()
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.accentColor, lineWidth: 2)
                )
        }
    }
}

#Preview {
    ProfileImageView(frameSize: 73)
}
