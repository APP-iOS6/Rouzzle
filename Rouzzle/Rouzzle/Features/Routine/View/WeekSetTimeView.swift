//
//  RoutineSetTime.swift
//  Rouzzle
//
//  Created by 이다영 on 11/5/24.
//

import SwiftUI

struct WeekSetTimeView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedDateWithTime: [Day: Date]
    @State private var selectedDay: Day = .sunday
    @State private var selectedTime: Date = Date() // 전체 시간을 설정할 때 사용할 시간
    @State private var showDaySheet = false
    @State private var showAllDaysPicker = false
    
    let allTimeChange: (Date) -> Void
    
    var body: some View {
        VStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.semibold20)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            Text("요일별 시간 설정")
                .font(.semibold20)
                .padding(.top, 8)
            
            // 전체 선택 버튼
            Button(action: {
                showAllDaysPicker.toggle()
            }, label: {
                HStack {
                    Spacer()
                    Text("한 번에 설정하기")
                    Image(systemName: "chevron.right")
                }.font(.regular14)
            })
            .padding(.top, 39)

            // 개별 요일 시간 설정 리스트
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Day.allCases, id: \.self) { day in
                        let selected = selectedDateWithTime[day] != nil
                        HStack {
                            Text("\(day.name)요일")
                                .strikethrough(!selected, color: Color(uiColor: .systemGray3))
                                .foregroundStyle(!selected ? Color(uiColor: .systemGray3) : .black)
                                .font(.semibold18)
                                .padding(.leading)
                            
                            Spacer()
                            
                            Text(selectedDateWithTime[day] ?? Date(), style: .time)
                                .strikethrough(!selected, color: Color(uiColor: .systemGray3))
                                .foregroundStyle(!selected ? Color(uiColor: .systemGray3) : .black.opacity(0.6))
                                .font(.regular18)
                                .padding(.horizontal)
                        }
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(uiColor: .systemGray5).opacity(0.4))
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedDay = day
                            selectedTime = selectedDateWithTime[day] ?? Date()
                            showDaySheet.toggle()
                        }
                        .disabled(!selected)
                    }
                }
                .padding(.horizontal, 3)
                .padding(.top, 10)
            }
            Spacer()
            
            // 저장하기 버튼
            RouzzleButton(buttonType: .complete, action: {
                dismiss()
            })
        }
        .padding()
        // 요일별 시간 피커
        .sheet(isPresented: $showDaySheet) {
            ReusableTimePickerSheet(time: $selectedTime) {
                selectedDateWithTime[selectedDay] = selectedTime
            }
        }
        // 한 번에 시간 피커
        .sheet(isPresented: $showAllDaysPicker) {
            ReusableTimePickerSheet(time: $selectedTime) {
                allTimeChange(selectedTime)
            }
        }
        .navigationBarBackButtonHidden()
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
            .padding(.bottom, -16)
            
            DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
        }
        .presentationDetents([detentForScreenSize()])
    }
    
    private func detentForScreenSize() -> PresentationDetent {
        let screenHeight = UIScreen.main.bounds.height
        if screenHeight <= 667 { // iPhone SE 크기 기준
            return .fraction(0.45)
        } else {
            return .fraction(0.4)
        }
    }
}

#Preview {
    NavigationStack {
        WeekSetTimeView(selectedDateWithTime: .constant([:])) {_ in 
            
        }
    }
}
