//
//  CalendarDayView2.swift
//  Rouzzle
//
//  Created by 김동경 on 11/18/24.
//

import SwiftUI

struct CalendarDayView: View {
    
    let completionStatus: CompletionState
    let value: DateValue
    let action: () -> Void
    
    var body: some View {
        ZStack {
            switch completionStatus {
            case .completed:
                Image(systemName: "puzzlepiece.extension.fill")
                    .font(.system(size: 35))
                    .foregroundStyle(Color.accentColor)
                    .transition(.opacity)
            case .halfCompleted:
                Image(systemName: "puzzlepiece.extension.fill")
                    .font(.system(size: 35))
                    .foregroundStyle(Color.partiallyCompletePuzzle)
                    .transition(.opacity)
            case .failed:
                EmptyView()
            }
 
            Button {
                action()
            } label: {
                Text("\(value.day)")
                    .font(.medium16)
                    .foregroundStyle(Color.primary)
                    .frame(width: 35, height: 35)
            }
        }
        .frame(height: 40)
    }
}

#Preview {
    CalendarDayView(completionStatus: .completed, value: .init(day: 1, date: Date())) {}
}
