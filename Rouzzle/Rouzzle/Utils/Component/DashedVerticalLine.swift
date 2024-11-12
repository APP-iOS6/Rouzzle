//
//  DashedVerticalLine.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/7/24.
//

import SwiftUI

struct DashedVerticalLine: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 1, y: 0))
            path.addLine(to: CGPoint(x: 1, y: 40))
        }
        .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [5, 5]))
        .foregroundStyle(Color.themeColor)
        .frame(width: 2, height: 40)
    }
}

#Preview {
    VStack {
        DashedVerticalLine()
    }
}
