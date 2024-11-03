//
//  RoutinePuzzle.swift
//  Rouzzle
//
//  Created by 김정원 on 11/3/24.
//

import SwiftUI

struct RoutinePuzzle: View {
    var body: some View {
        VStack {
            GeometryReader { proxy in
                ZStack {
                    Image("Routine")
                        .resizable()
                        .aspectRatio(370/137, contentMode: .fit)
                        .frame(width: proxy.size.width)
                    
                    HStack {
                        Image(systemName: "sun.max.fill")
                            .font(.title)
                            .padding(.horizontal)
                        VStack(alignment: .leading,spacing: 5) {
                            Text("아침 루틴")
                                .font(.title3)
                                .bold()
                            HStack {
                                Image(systemName: "clock")
                                Text("06:30")
                            }
                            .foregroundStyle(.secondary)
                            Text("매일")
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "circle.dotted")
                            .foregroundStyle(Color.fromRGB(r: 85, g: 138, b: 36))
                            .font(.title)
                    }
                    .padding(.horizontal, 20)
                    .offset(y: -5)
                }
            }
            .padding()
        }
    }
}

#Preview {
    RoutinePuzzle()
}
