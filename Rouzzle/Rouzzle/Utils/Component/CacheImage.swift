//
//  CacheImage.swift
//  Rouzzle
//
//  Created by 김정원 on 11/14/24.
//

import SwiftUI

struct CacheImage: View {
    @State var imageLoader: ImageLoader

    init(url: String) {
        imageLoader = ImageLoader(url: url)
    }

    var body: some View {
        ZStack {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ProfileCachedImage: View {
    private(set) var frameSize: CGFloat
    private(set) var imageUrl: String?
    
    var body: some View {
        if let imageUrl = imageUrl {
            CacheImage(url: imageUrl)
                .frame(width: frameSize, height: frameSize)
                .clipShape(Circle())
        } else {
            Image(.defaultProfile)
                .resizable()
                .scaleEffect(0.5)
                .scaledToFill()
                .frame(width: frameSize, height: frameSize)
                .clipShape(Circle())
                .background(Circle().fill(.white))
                .overlay(
                    Circle()
                        .stroke(Color.accentColor, lineWidth: 2)
                )
        }
    }
}
