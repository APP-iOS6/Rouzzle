//
//  RoutineStatisticView.swift
//  Rouzzle
//
//  Created by 김동경 on 11/20/24.
//

import SwiftUI

struct RoutineStatisticView: View {
    
    let routineStatistic: RoutineStatistic
    let proxy: GeometryProxy
    
    var body: some View {
        HStack(alignment: .center) {
            VStack {
                Text("\(routineStatistic.currentStreak)")
                    .font(.semibold24)
                Text("현재 연속일")
                    .font(.regular12)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical)
            .frame(maxWidth: proxy.size.width * 0.26)
            
            Divider()
            
            VStack {
                Text("\(routineStatistic.maxStreak)")
                    .font(.semibold24)
                Text("최대 연속일")
                    .font(.regular12)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical)
            .frame(maxWidth: proxy.size.width * 0.26)

            Divider()
            
            VStack {
                Text("\(routineStatistic.totalCompletedDays)")
                    .font(.semibold24)
                Text("누적 연속일")
                    .font(.regular12)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical)
            .frame(maxWidth: proxy.size.width * 0.26)

        }
        .padding()
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundLightGray)
        )
    }
}
