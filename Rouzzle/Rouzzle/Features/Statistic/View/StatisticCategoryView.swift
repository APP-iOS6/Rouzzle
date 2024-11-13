//
//  StatisticCategoryView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/13/24.
//

import SwiftUI

struct StatisticCategoryView: View {
    @State private var selectedCategory: String = "요약"
    let routines = RoutineItem.sampleData // 샘플 데이터

    // 모든 카테고리 (기본 + 루틴 목록)
    var allCategories: [String] {
        let defaultCategories = ["요약"]
        let routineTitles = routines.map { "\($0.emoji) \($0.title)" }
        return defaultCategories + routineTitles
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 루틴이 없을 경우
            if routines.isEmpty {
                Text("등록된 루틴이 없습니다")
                    .font(.medium16)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 16)
            } else {
                // 카테고리 목록
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(allCategories, id: \.self) { category in
                            let isSelected = (category == selectedCategory)
                            Text(category)
                                .font(.regular18)
                                .foregroundStyle(isSelected ? .white : .accentColor)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 18)
                                        .fill(isSelected ? Color.accentColor : Color.white)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(Color.accent, lineWidth: 1)
                                )
                                .onTapGesture {
                                    selectedCategory = category
                                }
                        }
                    }
                    .padding(.vertical, 1)
                    .frame(maxWidth: .infinity, alignment: .leading) // 이 부분을 추가
                }

                // 선택한 카테고리 뷰
                if selectedCategory == "요약" {
                    SummaryView()
                } else if let selectedRoutine = routines.first(where: { selectedCategory.contains($0.title) }) {
                    StatisticRoutineDetailView(routine: selectedRoutine)
                }
            }
        }
    }
}

// 개별 루틴 상세 뷰
struct StatisticRoutineDetailView: View {
    let routine: RoutineItem

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("루틴 이름: \(routine.title)")
                .font(.regular16)
            Text("이모지: \(routine.emoji)")
                .font(.regular16)
        }
        .padding()
    }
}

#Preview {
    StatisticCategoryView()
}
