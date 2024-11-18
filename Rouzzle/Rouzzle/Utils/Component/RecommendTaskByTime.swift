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
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.themeColor)
            
            Text(category.description)
                .font(.bold20)
                .padding()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 68)
    }
}

#Preview {
    RecommendTaskByTime(category: .morning)
}
