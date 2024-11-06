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
    @State private var isCustomTimePerDayEnabled = false
    
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
            
            // 요일별 설정 체크박스
            HStack {
                Spacer()
                Image(systemName: isCustomTimePerDayEnabled ? "checkmark.square" : "square")
                Text("요일별 설정")
                    .font(.regular14)
            }
            .foregroundColor(isCustomTimePerDayEnabled ? .black : .gray)
            .onTapGesture {
                isCustomTimePerDayEnabled.toggle()
            }
            
            // 개별 요일 시간 설정 리스트
            VStack(alignment: .leading, spacing: 8) {
                ForEach(selectedDays.sorted(), id: \.self) { day in
                    HStack {
                        Text("\(day)요일")
                            .foregroundColor(isCustomTimePerDayEnabled ? .primary : .gray)
                            .font(.semibold18)
                            .padding(.leading, 6)
                        Spacer()
                        Text(times[day]!, style: .time)
                            .foregroundColor(isCustomTimePerDayEnabled ? .primary : .gray)
                            .font(.regular18)
                        Image(systemName: "chevron.right")
                            .foregroundColor(isCustomTimePerDayEnabled ? .primary : .gray)
                    }
                    .padding(.vertical, 10)
                    
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if isCustomTimePerDayEnabled {
                            selectedDay = day
                            showSheet = true
                        }
                    }
                    .disabled(!isCustomTimePerDayEnabled)
                    Divider()
                    
                }
            }
            .padding(.horizontal, 3)
            .padding(.top, 10)
            
            Spacer()
            
            // 저장하기 버튼
            RouzzleButton(buttonType: .save, action: {
                print("Selected times: \(times)")
            })
            .padding(.bottom, 15)
        }
        .customNavigationBar(title: "시간 설정")
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
            Text("\(selectedDay)요일 시간 설정")
                .font(.regular20)
                .padding(.top, 60)
            
            DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .frame(height: 260)
            
            Button("닫기") {
                dismiss()
            }
            .padding(.top, 20)
        }
        .padding(.top, 10)
    }
}

#Preview {
    RoutineSetTimeView(selectedDays: ["월", "화", "수", "목", "금"])
}
