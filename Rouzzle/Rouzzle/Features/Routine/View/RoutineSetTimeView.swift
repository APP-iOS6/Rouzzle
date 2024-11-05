//
//  RoutineSetTime.swift
//  Rouzzle
//
//  Created by 이다영 on 11/5/24.
//

import SwiftUI

struct RoutineSetTimeView: View {
    @State private var selectedTime: Date = Date()
    @State private var times: [String: Date] = [
        "월요일": Date(),
        "화요일": Date(),
        "수요일": Date(),
        "목요일": Date(),
        "금요일": Date()
    ]
    @State private var selectedDay: String?

    var body: some View {
        VStack {
            DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .frame(height: 150)
                .onChange(of: selectedTime) { newTime in
                    if let day = selectedDay {
                        times[day] = newTime
                    }
                }

            List {
                Section(header: Text("요일별 시간 설정")) {
                    ForEach(times.keys.sorted(), id: \.self) { day in
                        HStack {
                            Text(day)
                            Spacer()
                            Button(action: {
                                selectedDay = day
                                selectedTime = times[day] ?? Date()
                            }, label: {
                                Text(times[day]!, style: .time)
                                    .foregroundColor(.primary)
                            })
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            
            RouzzleButton(buttonType: .save, action: {})
        }
        .customNavigationBar(title: "시작 시간 설정")
    }
}

#Preview {
    RoutineSetTimeView()
}
