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
    @State private var temporaryTime: Date = Date() // 임시 시간을 저장할 변수
    
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
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.semibold24)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 20)
            
            // 전체 선택 버튼
            Button(action: {
                temporaryTime = allDaysTime // 현재 값을 임시 저장
                showAllDaysPicker = true
            }, label: {
                HStack {
                    Spacer()
                    Text("한 번에 설정하기")
                    Image(systemName: "chevron.right")
                }.font(.regular14)
            })
            .padding(.top, 39)

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
                            temporaryTime = times[day] ?? Date() // 현재 값을 임시 저장
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
        }
        .padding()
        // 요일별 시간 피커
        .sheet(isPresented: $showSheet) {
            if let selectedDay = selectedDay {
                ReusableTimePickerSheet(
                    time: $temporaryTime,
                    onConfirm: {
                        times[selectedDay] = temporaryTime
                    }
                )
            }
        }
        // 한 번에 시간 피커
        .sheet(isPresented: $showAllDaysPicker) {
            ReusableTimePickerSheet(
                time: $temporaryTime,
                onConfirm: {
                    allDaysTime = temporaryTime
                    for day in selectedDays {
                        times[day] = allDaysTime
                    }
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
                Button("취소") {
                    dismiss()
                }
                
                Spacer()
                
                Button("완료") {
                    onConfirm()
                    dismiss()
                }
                .foregroundColor(.accent)
            }
            .padding()
            
            DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .frame(height: 250)
        }
        .presentationDetents([.fraction(0.4)])
    }
}

#Preview {
    NavigationStack {
        WeekSetTimeView(selectedDays: ["월", "화", "수", "목", "금"])
    }
}
