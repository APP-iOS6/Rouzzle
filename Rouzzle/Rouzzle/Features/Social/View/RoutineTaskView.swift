//
//  RoutineTaskView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/15/24.
//

import Foundation
import SwiftUI

struct RoutineTasksView: View {
    var routine: Routine
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(getRoutineTimeRangeString(routine: routine))
                .font(.light12)
                .foregroundColor(.gray)
            
            ForEach(routine.routineTask, id: \.self) { task in
                HStack(spacing: 2) {
                    Text(task.emoji)
                    Text(task.title)
                        .font(.regular12)
                        .padding(.leading, 4)
                    Spacer()
                    Text("\(task.timer/60)분")
                        .font(.regular12)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
