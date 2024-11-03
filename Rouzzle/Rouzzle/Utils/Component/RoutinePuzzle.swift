//
//  RoutinePuzzle.swift
//  Rouzzle
//
//  Created by 김정원 on 11/3/24.
//

import SwiftUI

struct RoutinePuzzleInfo {
    var mainImage: String
    var routineTitle: String
    var routineStartTime: String
    var isCompleted: Bool
    var cyclePeriod: String
}

struct RoutinePuzzle: View {
    private(set) var info: RoutinePuzzleInfo
    var body: some View {
        VStack {
            GeometryReader { proxy in
                ZStack {
                    Image("Routine")
                        .resizable()
                        .aspectRatio(370/137, contentMode: .fit)
                        .frame(width: proxy.size.width)
                    
                    HStack {
                        Image(systemName: "\(info.mainImage)")
                            .font(.title)
                            .padding(.horizontal, 10)
                        VStack(alignment: .leading, spacing: 5) {
                            Text(info.routineTitle)
                                .font(.title3)
                                .bold()
                            HStack {
                                Image(systemName: "clock")
                                Text(info.routineStartTime)
                            }
                            .foregroundStyle(Color.subHeadlineFontColor)
                            Text(info.cyclePeriod)
                                .foregroundStyle(Color.subHeadlineFontColor)
                        }
                        Spacer()
                        Image(systemName: info.isCompleted ? "checkmark.circle" : "circle.dotted")
                            .foregroundStyle(Color.fromRGB(r: 85, g: 138, b: 36))
                            .font(.title)
                    }
                    .padding(.horizontal, 20)
                    .offset(y: -5)
                }
            }
        }
    }
}

#Preview {
    RoutinePuzzle(info: RoutinePuzzleInfo(mainImage: "sun.max.fill", routineTitle: "아침 루틴", routineStartTime: "06:30", isCompleted: true, cyclePeriod: "매일"))
}
