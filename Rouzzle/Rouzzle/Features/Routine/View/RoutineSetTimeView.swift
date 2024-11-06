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
    @State private var showSheet = false
    
    init(selectedDays: [String]) {
        self.selectedDays = selectedDays
        _times = State(initialValue: selectedDays.reduce(into: [:]) { result, day in
            result[day] = Date()
        })
    }
    
    var body: some View {
        VStack {
            // 전체 요일 설정하는 상단 DatePicker
            DatePicker("", selection: Binding(
                get: {
                    if let selectedDay = selectedDay {
                        return times[selectedDay] ?? Date()
                    }
                    return Date()
                },
                set: { newValue in
                    for day in selectedDays {
                        times[day] = newValue // 모든 요일의 시간을 동일하게 설정
                    }
                }
            ), displayedComponents: .hourAndMinute)
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            .frame(height: 200)
            .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 10) {
                ForEach(selectedDays.sorted(), id: \.self) { day in
                    HStack {
                        Text(day)
                            .font(.headline)
                        Spacer()
                        Text(times[day]!, style: .time)
                            .foregroundColor(.primary)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 10)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedDay = day
                        showSheet = true
                    }
                    Divider()
                }
                .listStyle(PlainListStyle())
            }
            .padding(.top, 20)
            Spacer()
            // 저장하기
            RouzzleButton(buttonType: .save, action: {
                print("Selected times: \(times)")
            })
        }
        .customNavigationBar(title: "요일별 시간 설정")
        .sheet(isPresented: $showSheet) {
            if let selectedDay = selectedDay, let bindingTime = Binding($times[selectedDay]) {
                DayTimePickerSheet(selectedDay: selectedDay, time: bindingTime)
                    .presentationDetents([.fraction(0.4)])
            }
        }
    }
}

// 개별 요일 시간을 설정하기 위한 시트 뷰
struct DayTimePickerSheet: View {
    var selectedDay: String
    @Binding var time: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("\(selectedDay) 시간 설정")
                .font(.headline)
                .padding(.top, 20)
            
            DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .frame(height: 260)
        }
        .padding(.top, 10)
    }
}

#Preview {
    RoutineSetTimeView(selectedDays: ["월요일", "화요일", "수요일", "목요일", "금요일"])
}
