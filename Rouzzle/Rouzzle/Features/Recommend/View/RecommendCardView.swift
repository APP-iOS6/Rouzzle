//
//  RecommendCardView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/11/24.
//

import SwiftUI

struct RecommendCardView: View {
    let card: Card
    let animation: Namespace.ID
    let onTap: () -> Void

    var body: some View {
        HStack(spacing: 15) {
            Text(card.imageName)
                .font(.system(size: 50))
                .frame(width: 60, height: 60)
                .matchedGeometryEffect(id: "image\(card.id)", in: animation)
            
            Text(card.title)
                .font(.semibold18)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .matchedGeometryEffect(id: "title\(card.id)", in: animation)
            
            Spacer()
            Image(systemName: "chevron.down")
                .foregroundStyle(.graymedium)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 13)
                .stroke(Color.graylight, lineWidth: 1)
                .matchedGeometryEffect(id: "background\(card.id)", in: animation)
        )
        .onTapGesture(perform: onTap)
    }
}

#Preview {
    RecommendCardView(
        card: DummyCardData.celebrityCards.first!,
        animation: Namespace().wrappedValue,
        onTap: {}
    )
}
