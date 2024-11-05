//
//  AddRoutineView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import SwiftUI

struct AddRoutineView: View {
    @State private var title: String = ""
    @State private var selectedDays: Set<String> = []
    @State private var isDaily: Bool = false
    @State private var startTime: Date = Date()
    @State private var isNotificationEnabled: Bool = false
    @State private var isOneAlarm: Bool = false
    
    @State private var selectedMinute: Int = 5
    @State private var selectedCount: Int = 3
    let minutes = [1, 3, 5, 7, 10]
    let counts = [1, 2, 3, 4, 5]
    
    var daysOfWeek = ["월", "화", "수", "목", "금", "토", "일"]

    var body: some View {
        VStack {
            // 이모지 입력
            VStack {
                EmojiButton(emojiButtonType: .routineEmoji) { selectedEmoji in                    print("Selected Emoji: \(selectedEmoji)")
                }
                .padding(.vertical, 45)
            }
            
            // 첫번째 네모칸(제목, 요일, 시간)
            VStack(alignment: .leading, spacing: 20) {
                // 제목 입력 필드
                RouzzleTextField(text: $title, placeholder: "제목을 입력해주세요")
                    .accentColor(Color("buttonColor"))
                
                // 반복 요일 섹션
                HStack {
                    Text("반복 요일")
                        .font(.headline)
                    Spacer()
                    // 매일 체크박스
                    HStack {
                        CheckBoxView(isChecked: $isDaily)
                        Text("매일")
                            .font(.body)
                            .foregroundColor(isDaily ? .black : .gray)
                    }
                    .onChange(of: isDaily) {
                        selectedDays = isDaily ? Set(daysOfWeek) : []
                    }
                }
                
                // 요일 선택 버튼
                HStack(spacing: 15) {
                    ForEach(daysOfWeek, id: \.self) { day in
                        dayButton(for: day)
                    }
                }
                
                Divider()
                    .padding(.vertical, 2)
                
                HStack {
                    Text("시작 시간")
                        .font(.headline)
                    Spacer()
                    VStack {
                        NavigationLink(destination: RoutineSetTimeView()) {
                            HStack {
                                Text("요일별 시간 설정")
                                    .font(.caption)
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12))
                            }
                        }.foregroundColor(.gray)
                        
                        DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()
                            .cornerRadius(10)
                            .accentColor(Color("buttonColor"))
                    }
                }
            }
            .padding()
            .background(Color.fromRGB(r: 248, g: 247, b: 247))
            .cornerRadius(20)
            
            // 두 번째 네모칸(알림설정)
            VStack(alignment: .leading, spacing: 20) {
                // 알림 설정 제목 및 스위치
                HStack {
                    Text("루틴 시작 알림")
                        .font(.headline)
                    Spacer()
                    Toggle(isOn: $isNotificationEnabled) {
                        Text("")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: Color("buttonColor")))
                }
                
                // 알림 On일 때 활성화
                if isNotificationEnabled {
                    Divider() // 구분선
                    
                    // 알림 빈도 설정
                    VStack(alignment: .leading, spacing: 10) {
                        Text("알림 빈도")
                            .font(.headline)
                        
                        HStack(spacing: 10) {
                            // 분 선택 Picker
                            CustomPicker(
                                label: "분",
                                selection: $selectedMinute,
                                options: minutes.map { "\($0)분" },
                                isDisabled: isOneAlarm
                            )
                            
                            Text("마다")
                                .foregroundColor(isOneAlarm ? .gray : .primary)
                            
                            // 횟수 선택 Picker
                            CustomPicker(
                                label: "횟수",
                                selection: $selectedCount,
                                options: counts.map { "\($0)회" },
                                isDisabled: isOneAlarm
                            )
                            
                            Spacer()
                            
                            // 알람 체크박스
                            HStack {
                                CheckBoxView(isChecked: $isOneAlarm)
                                Text("1회만")
                                    .foregroundColor(isOneAlarm ? .black : .gray)
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color.fromRGB(r: 248, g: 247, b: 247))
            .cornerRadius(20)

            Spacer()
        }
        .customNavigationBar(title: "루틴 등록")
    }
    
    // 요일 선택 버튼
    private func dayButton(for day: String) -> some View {
            ZStack {
                Image(selectedDays.contains(day) ? "dayButtonOn" : "dayButtonOff")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Text(day)
                    .font(.caption)
                    .foregroundColor(selectedDays.contains(day) ? .black : .gray)
            }
            .onTapGesture {
                if selectedDays.contains(day) {
                    selectedDays.remove(day)
                } else {
                    selectedDays.insert(day)
                }
                isDaily = selectedDays.count == daysOfWeek.count
            }
        }
}

// CustomPicker 뷰
struct CustomPicker: View {
    let label: String
    @Binding var selection: Int
    let options: [String]
    let isDisabled: Bool
    
    var body: some View {
        Picker(label, selection: $selection) {
            ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                Text(option).tag(index)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .frame(height: 40)
        .background(Color.white)
        .cornerRadius(10)
        .accentColor(Color("buttonColor"))
        .disabled(isDisabled)
    }
}

// 체크박스
struct CheckBoxView: View {
    @Binding var isChecked: Bool
    
    var body: some View {
        Button(action: {
            isChecked.toggle()
        }, label: {
            Image(systemName: isChecked ? "checkmark.square" : "square")
                .foregroundColor(isChecked ? .black : .gray)
        })
    }
}

#Preview {
    NavigationStack {
        AddRoutineView()
    }
} 
