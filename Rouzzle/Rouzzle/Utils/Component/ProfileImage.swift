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
    
    var body: some View {
        Image(systemName: "person.fill")
            .font(.bold50)
            .foregroundStyle(.accent)
            .frame(width: frameSize, height: frameSize)
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
    var profileImage: UIImage
    
    var body: some View {
        Image(uiImage: profileImage)
            .resizable()
            .scaledToFill()
            .frame(width: frameSize, height: frameSize)
            .clipShape(Circle())
    }
}
