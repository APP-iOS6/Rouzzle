//
//  StatsView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import SwiftUI

struct StatisticView: View {
    @State var viewModel = StatisticViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Text("통계")
                            .font(.semibold18)
                            .foregroundStyle(.basic)
                        Spacer()
                        PieceCounter(count: 9)
                    }
                    .padding(.top, 20)
                    
                    StatisticCategoryView()
                        .padding(.top, 20)
                }
                .padding(.horizontal)
                .padding(.bottom, 200)
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    StatisticView()
}
