//
//  RoutineSetTime.swift
//  Rouzzle
//
//  Created by 이다영 on 11/5/24.
//

import SwiftUI

struct RoutineSetTimeView: View {
    @Environment(\.dismiss) private var dismiss
    let allDays = ["월", "화", "수", "목", "금", "토", "일"]
    let selectedDays: [String]
    @State private var times: [String: Date]
    @State private var selectedDay: String?
    @State private var showSheet = false
    @State private var isCustomTimePerDayEnabled = false
    
    init(selectedDays: [String]) {
        self.selectedDays = selectedDays
        // 기본 시간은 오전 8시 30분으로 설정
        let defaultTime = Calendar.current.date(bySettingHour: 8, minute: 30, second: 0, of: Date())!
        _times = State(initialValue: allDays.reduce(into: [:]) { result, day in
            result[day] = selectedDays.contains(day) ? Date() : defaultTime
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
                        times[day] = newValue
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
                ForEach(allDays, id: \.self) { day in
                    HStack {
                        Text("\(day)요일")
                            .strikethrough(!selectedDays.contains(day), color: .gray)
                            .foregroundColor(selectedDays.contains(day) ? (isCustomTimePerDayEnabled ? .accent : .gray) : .gray)
                            .font(.semibold18)
                            .padding(.leading, 6)
                        Spacer()
                        if let time = times[day] {
                            Text(time, style: .time)
                                .strikethrough(!selectedDays.contains(day), color: .gray)
                                .foregroundColor(selectedDays.contains(day) ? (isCustomTimePerDayEnabled ? .accent : .gray) : .gray)
                                .font(.regular18)
                        }
                        Image(systemName: "chevron.right")
                            .foregroundColor(selectedDays.contains(day) && isCustomTimePerDayEnabled ? .accent : .gray)
                    }
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8) // 모서리 둥글기를 설정
                            .fill(selectedDay == day && isCustomTimePerDayEnabled ? Color(.systemGray5) : Color.clear)
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if isCustomTimePerDayEnabled && selectedDays.contains(day) {
                            selectedDay = day
                            showSheet = true
                        }
                    }
                    .disabled(!selectedDays.contains(day) || !isCustomTimePerDayEnabled)
                    Divider()
                }
            }
            .padding(.horizontal, 3)
            .padding(.top, 10)
            
            Spacer()
            
            // 저장하기 버튼
            RouzzleButton(buttonType: .save, action: {
                print("Selected times: \(times)")
                dismiss()
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
