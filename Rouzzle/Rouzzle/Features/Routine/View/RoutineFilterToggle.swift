//
//  RoutineFilterToggle.swift
//  Rouzzle
//
//  Created by 이다영 on 11/15/24.
//
import SwiftUI

enum FilterOption {
    case today
    case all
}

struct RoutineFilterToggle: View {
    @Binding var selectedFilter: FilterOption
    // 애니메이션 네임스페이스
    @Namespace private var toggleAnimation
    // 필터 옵션 리스트
    private let filterOptions = ["Today", "All"]

    var body: some View {
        ZStack(alignment: .leading) {
            HStack(spacing: 0) {
                ForEach(filterOptions.indices, id: \.self) { index in
                    let isAll = filterOption(at: index) == .all
                    ToggleAnimationView(
                        isActive: selectedFilter == filterOption(at: index),
                        isAll: isAll,
                        content: Text(filterOptions[index])
                            .font(.semibold14)
                            .frame(width: 40, height: 31)
                            .padding(.horizontal, 8)
                            .foregroundColor(selectedFilter == filterOption(at: index) ? .accentColor : .gray)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    selectedFilter = filterOption(at: index)
                                }
                            }
                    )
                }
            }
        }
        .padding(2)
        .frame(height: 35)
        .background(
            RoundedRectangle(cornerRadius: 23)
                .stroke(.white, lineWidth: 1)
                .background(Color.toggleGray)
                .clipShape(RoundedRectangle(cornerRadius: 23))
        )
    }

    /// 애니메이션을 포함한 ViewBuilder
    @ViewBuilder func ToggleAnimationView<Content: View>(isActive: Bool, isAll: Bool, content: Content) -> some View {
        if isActive {
            content
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundColor(.white)
                        .padding(2)
                        .matchedGeometryEffect(id: "highlightitem", in: toggleAnimation)
                )
        } else {
            content
        }
    }

    /// 인덱스를 기준으로 필터 옵션 반환
    private func filterOption(at index: Int) -> FilterOption {
        return index == 0 ? .today : .all
    }
}

#Preview {
    NavigationStack {
        RoutineListView()
            .modelContainer(SampleData.shared.modelContainer)
    }
}
