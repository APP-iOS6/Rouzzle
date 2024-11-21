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
                Circle()
                    .frame(width: 34)
                    .foregroundStyle(Color.calendarCompleted)
                    .transition(.opacity)
            case .halfCompleted:
                Circle()
                    .frame(width: 34)
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
                    .foregroundStyle(completionStatus == .completed ? .white : .black)
                    .frame(width: 35, height: 35)
            }
        }
        .frame(height: 40)
    }
}

#Preview {
    CalendarDayView(completionStatus: .completed, value: .init(day: 28, date: Date())) {}
}
