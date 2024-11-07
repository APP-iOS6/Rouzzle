//
//  RoutineSetTime.swift
//  Rouzzle
//
//  Created by 이다영 on 11/5/24.
//

import SwiftUI

struct WeekSetTimeView: View {
    @Environment(\.dismiss) private var dismiss
    let allDays = ["월", "화", "수", "목", "금", "토", "일"]
    let selectedDays: [String]
    @State private var times: [String: Date]
    @State private var selectedDay: String?
    @State private var showSheet = false
    @State private var showAllDaysPicker = false
    @State private var allDaysTime: Date = Date() // 전체 시간을 설정할 때 사용할 시간
    
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
            // 전체 선택 버튼
            Button(action: {
                showAllDaysPicker = true
            }, label: {
                HStack {
                    Spacer()
                    Text("한 번에 설정하기")
                    Image(systemName: "chevron.right")
                }.font(.regular14)
            })

            // 개별 요일 시간 설정 리스트
            VStack(alignment: .leading, spacing: 12) {
                ForEach(allDays, id: \.self) { day in
                    HStack {
                        Text("\(day)요일")
                            .strikethrough(!selectedDays.contains(day), color: Color(.systemGray3))
                            .foregroundColor(selectedDays.contains(day) ? .black : Color(.systemGray3))
                            .font(.semibold18)
                            .padding(.leading, 15)
                        Spacer()
                        if let time = times[day] {
                            Text(time, style: .time)
                                .strikethrough(!selectedDays.contains(day), color: Color(.systemGray3))
                                .foregroundColor(selectedDays.contains(day) ? Color(.black).opacity(0.6) : Color(.systemGray3))
                                .font(.regular18)
                                .padding(.horizontal, 15)
                        }
                    }
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray5).opacity(0.4))
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if selectedDays.contains(day) {
                            selectedDay = day
                            showSheet = true
                        }
                    }
                    .disabled(!selectedDays.contains(day))
                }
            }
            .padding(.horizontal, 3)
            .padding(.top, 10)
            
            Spacer()
            
            // 저장하기 버튼
            RouzzleButton(buttonType: .complete, action: {
                print("Selected times: \(times)")
                dismiss()
            })
            .padding(.bottom, 15)
        }
        .padding(.top, 70)
        .customNavigationBar(title: "요일별 시간 설정")
        // 요일별 시간 피커
        .sheet(isPresented: $showSheet) {
            if let selectedDay = selectedDay, let bindingTime = Binding($times[selectedDay]) {
                ReusableTimePickerSheet(
                    time: bindingTime,
                    onConfirm: { dismiss() }
                )
            }
        }
        // 한 번에 시간 피커
        .sheet(isPresented: $showAllDaysPicker) {
            ReusableTimePickerSheet(
                time: $allDaysTime,
                onConfirm: {
                    for day in selectedDays {
                        times[day] = allDaysTime
                    }
                    showAllDaysPicker = false
                }
            )
        }
    }
}

// DatePicker Sheet
struct ReusableTimePickerSheet: View {
    @Binding var time: Date
    var onConfirm: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text("취소")
                        .foregroundStyle(.basic)
                }
                
                Spacer()
                
                Button {
                    onConfirm()
                    dismiss()
                } label: {
                    Text("완료")
                        .foregroundStyle(.basic)
                }
            }
            
            HStack {
                DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .frame(height: 250)
            }
        }
        .presentationDetents([.fraction(0.3)])
    }
}

#Preview {
    NavigationStack {
        WeekSetTimeView(selectedDays: ["월", "화", "수", "목", "금"])
    }
}
