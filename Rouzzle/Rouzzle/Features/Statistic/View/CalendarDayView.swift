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
        let isToday = Calendar.current.isDateInToday(value.date)
        VStack {
            Button {
                action()
            } label: {
                Text("\(value.day)")
                    .padding(4)
                    .font(.medium16)
                    .background(isToday ? Color.black : .clear)
                    .clipShape(.circle)
                    .foregroundStyle(isToday ? .white : .black)
                    .frame(width: 35, height: 35)
            }
        }
        .overlay(alignment: .bottom) {
            switch completionStatus {
            case .completed:
                Circle()
                    .frame(width: 6, height: 6)
                    .foregroundStyle(Color.calendarCompleted)
                    .transition(.opacity)
                    .offset(y: 6)
            case .halfCompleted:
                Circle()
                    .frame(width: 6, height: 6)
                    .foregroundStyle(Color.partiallyCompletePuzzle)
                    .transition(.opacity)
                    .offset(y: 6)
            case .failed:
                EmptyView()
            }
        }
    }
}

#Preview {
    CalendarDayView(completionStatus: .completed, value: .init(day: 28, date: Date())) {}
}
