//
//  RegisteredRoutinesView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/13/24.
//

import SwiftUI

struct RegisteredRoutinesView: View {
    let routines: [RoutineItem]

    var body: some View {
        VStack {
            ForEach(routines) { routine in
                HStack {
                    Text(routine.emoji)
                        .font(.largeTitle)
                    Text(routine.title)
                        .font(.bold18)
                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                )
            }
        }
    }
}
