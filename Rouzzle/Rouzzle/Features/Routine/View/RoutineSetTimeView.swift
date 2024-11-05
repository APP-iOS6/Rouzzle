//
//  RoutineSetTime.swift
//  Rouzzle
//
//  Created by 이다영 on 11/5/24.
//

import SwiftUI

struct RoutineSetTimeView: View {
    let selectedDays: [String]
    @State private var times: [String: Date]
    @State private var selectedDay: String?
    
    init(selectedDays: [String]) {
        self.selectedDays = selectedDays
        _times = State(initialValue: selectedDays.reduce(into: [:]) { result, day in
            result[day] = Date()
        })
    }

    var body: some View {
        VStack {
            // DatePicker for the selected day
            if let selectedDay = selectedDay {
                DatePicker("", selection: Binding(
                    get: { times[selectedDay] ?? Date() },
                    set: { times[selectedDay] = $0 }
                ), displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .frame(height: 260)
            } else {
                // Placeholder when no day is selected
                Text("요일을 선택하세요")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .frame(height: 260)
            }
            
            // List of days and times
            VStack(alignment: .leading, spacing: 10) {
                Text("요일별 시간 설정")
                    .font(.headline)
                    .padding(.horizontal)

                List {
                    ForEach(selectedDays, id: \.self) { day in
                        HStack {
                            Text(day)
                            Spacer()
                            Text(times[day]!, style: .time)
                                .foregroundColor(.primary)
                        }
                        .contentShape(Rectangle()) // Make the entire row tappable
                        .onTapGesture {
                            selectedDay = day
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }

            // Save button
            RouzzleButton(buttonType: .save, action: {
                // Handle save action
                print("Selected times: \(times)")
            })
            .padding()
        }
        .padding()
        .customNavigationBar(title: "시작 시간 설정")
    }
}

#Preview {
    RoutineSetTimeView(selectedDays: ["월요일", "화요일", "수요일", "목요일", "금요일"])
}
