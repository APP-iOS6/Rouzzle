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
                .foregroundStyle(.black)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .matchedGeometryEffect(id: "title\(card.id)", in: animation)
            
            Image(systemName: "chevron.down")
                .foregroundStyle(.graymedium)
                .font(.system(size: 20, weight: .regular))

            Spacer()
        }
        .padding()
        .padding(.leading, 5)
        .frame(width: 370, height: 80)
        .background(
            RoundedRectangle(cornerRadius: 13)
                .stroke(Color.graylight, lineWidth: 1)
                .matchedGeometryEffect(id: "background\(card.id)", in: animation)
        )
        .onTapGesture(perform: onTap)
        .padding([.horizontal])
    }
}

#Preview {
    @Previewable @Namespace var animationNamespace
    RecommendCardView(
        card: Card(
            title: "오타니 쇼헤이",
            imageName: "⚾️",
            fullText: "오타니 쇼헤이는 세계적인 야구 선수로, 그의 하루는 철저한 관리와 노력으로 이루어져 있습니다. 아침부터 밤까지 최상의 컨디션을 유지하기 위한 특별한 루틴을 따릅니다.",
            routines: []
        ),
        animation: animationNamespace,
        onTap: {
        }
    )
}
