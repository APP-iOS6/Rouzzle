//
//  RoutineSetTimeView.swift
//  Rouzzle
//
//  Created by 이다영 on 11/7/24.
//

import SwiftUI

struct RoutineSetTimeView: View {
    @Environment(\.dismiss) private var dismiss
    let selectedDays: [String]
    @State private var selectedTime: Date = Date() // 기본 시간 설정
    @State private var showTimePickerSheet = false
    @State private var showWeekSetTimeView = false
    
    var body: some View {
        VStack {
            Spacer()
            // 중앙에 시간 크게 표시
            Text(selectedTime, style: .time)
                .font(.system(size: 48, weight: .bold))
                .padding(.top, 100)
                .onTapGesture {
                    showTimePickerSheet = true // 시간 선택 피커 표시
                }
                .frame(maxWidth: 300, alignment: .center)
            
            // 요일별 시간 설정 버튼
            Button(action: {
                showWeekSetTimeView = true
            }, label: {
                HStack {
                    Text("요일별 시간 설정")
                        .foregroundColor(.gray)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
            })
            
            Spacer()
            
            // 완료 버튼
            RouzzleButton(buttonType: .complete, action: {
                print("완료 버튼 눌림")
                dismiss()
            })
            .padding()
        }
        .customNavigationBar(title: "시간 설정")
        .sheet(isPresented: $showTimePickerSheet) {
            TimePickerSheet(time: $selectedTime)
        }
        .fullScreenCover(isPresented: $showWeekSetTimeView) {
            WeekSetTimeView(selectedDays: selectedDays)
        }
    }
}

struct TimePickerSheet: View {
    @Binding var time: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Button("취소") {
                    dismiss()
                }
                .padding(.leading, 16)
                
                Spacer()
                
                Button("완료") {
                    dismiss()
                }
                .foregroundColor(.green)
                .padding(.trailing, 16)
            }
            .padding(.vertical, 10)
            
            DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .frame(height: 250)
                .padding(.horizontal)
        }
        .presentationDetents([.fraction(0.4)])
    }
}

#Preview {
    NavigationStack {
        AddRoutineView()
    }
}
