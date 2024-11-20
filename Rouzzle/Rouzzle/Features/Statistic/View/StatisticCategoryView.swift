//
//  StatisticCategoryView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/13/24.
//

import SwiftUI

struct StatisticCategoryView: View {
    @Binding var selectedCategory: String
    let routines: [RoutineItem]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                Text("요약")
                    .font(.semibold16)
                    .foregroundStyle( selectedCategory == "요약" ? .accent : .graymedium)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(selectedCategory == "요약" ? Color.opacityGreen : Color.white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(selectedCategory == "요약" ? Color.accent : .graymedium, lineWidth: 1)
                    )
                    .onTapGesture {
                        selectedCategory = "요약"
                    }
                ForEach(routines, id: \.id) { routine in
                    let title = "\(routine.emoji) \(routine.title)"
                    let isSelected = title == selectedCategory
                    Text(title)
                        .font(.semibold16)
                        .foregroundStyle(isSelected ? .accent : .graymedium)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(isSelected ? Color.opacityGreen : Color.white)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(isSelected ? Color.accent : .graymedium, lineWidth: 1)
                        )
                        .onTapGesture {
                            selectedCategory = title
                        }
                }
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 1)
        }
    }
}
