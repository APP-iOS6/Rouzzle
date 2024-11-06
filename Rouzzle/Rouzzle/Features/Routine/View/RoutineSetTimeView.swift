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
            if let selectedDay = selectedDay {
                DatePicker("", selection: Binding(
                    get: { times[selectedDay] ?? Date() },
                    set: { times[selectedDay] = $0 }
                ), displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .frame(height: 260)
            } else {
                Text("요일을 선택하세요")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .frame(height: 260)
            }
            
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
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedDay = day
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }

            // 저장하기
            RouzzleButton(buttonType: .save, action: {
                print("Selected times: \(times)")
            })
        }
        .customNavigationBar(title: "시작 시간 설정")
    }
}

#Preview {
    RoutineSetTimeView(selectedDays: ["월요일", "화요일", "수요일", "목요일", "금요일"])
}
