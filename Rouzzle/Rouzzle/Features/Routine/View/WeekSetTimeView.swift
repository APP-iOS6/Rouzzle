//
//  RoutineSetTime.swift
//  Rouzzle
//
//  Created by 이다영 on 11/5/24.
//

import SwiftUI

struct WeekSetTimeView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var viewModel: AddRoutineViewModel
    @State private var selectedDay: Day = .sunday
    @State private var selectedTime: Date = Date() // 전체 시간을 설정할 때 사용할 시간
    @State private var showDaySheet = false
    @State private var showAllDaysPicker = false
    
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
            
            Text("요일별 시간 설정")
                .font(.semibold20)
                .padding(.top, 8)
            
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
            .padding(.top, 39)

            // 개별 요일 시간 설정 리스트
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Day.allCases, id: \.self) { day in
                        let selected = viewModel.selectedDateWithTime[day] != nil
                        HStack {
                            Text("\(day.name)요일")
                                .strikethrough(!selected, color: Color(uiColor: .systemGray3))
                                .foregroundStyle(!selected ? Color(uiColor: .systemGray3) : .black)
                                .font(.semibold18)
                                .padding(.leading)
                            
                            Spacer()
                            
                            Text(viewModel.selectedDateWithTime[day] ?? Date(), style: .time)
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
                            selectedTime = viewModel.selectedDateWithTime[day] ?? Date()
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
                viewModel.selectedDateWithTime[selectedDay] = selectedTime
            }
        }
        // 한 번에 시간 피커
        .sheet(isPresented: $showAllDaysPicker) {
//            ReusableTimePickerSheet(
//                time: $temporaryTime,
//                onConfirm: {
//                    allDaysTime = temporaryTime
//                    for day in selectedDays {
//                        times[day] = allDaysTime
//                    }
//                }
//            )
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
        WeekSetTimeView(viewModel: .init())
    }
}
