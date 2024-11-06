//
//  RecommendTaskByTime.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/7/24.
//

import SwiftUI

struct RecommendTaskByTime: View {
    let category: RoutineCategoryByTime
    
    var body: some View {
        ZStack {
            Image(.recommendTaskByTime)
                .resizable()
                .frame(maxWidth: .infinity)
                .aspectRatio(370 / 71, contentMode: .fit)
            
            Text(category.description)
                .font(.bold20)
        }
        .padding()
    }
}

#Preview {
    VStack(spacing: 16) {
        RecommendTaskByTime(category: .morning)
    }
    .padding()
}
