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
                    .scaledToFill()
            } else {
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ProfileCachedImage: View {
    private(set) var imageUrl: String?

    var body: some View {
        ZStack {
            if let imageUrl = imageUrl {
                CacheImage(url: imageUrl)
            } else {
                Group {
                    Image(.defaultProfile)
                        .resizable()
                        .scaleEffect(0.4)
                }
                .scaledToFill()
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.accentColor, lineWidth: 2)
                )
            }
        }

    }
}
