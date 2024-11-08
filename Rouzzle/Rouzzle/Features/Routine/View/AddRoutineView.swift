//
//  AddRoutineView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import SwiftUI

struct AddRoutineView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var selectedDays: Set<String> = []
    @State private var isDaily: Bool = false
    @State private var startTime: Date = Date()
    @State private var isNotificationEnabled: Bool = false
    @State private var isOneAlarm: Bool = false
    @State private var selectedMinute: Int = 2
    @State private var selectedCount: Int = 1
    @State private var selectedEmoji: String? = "🧩"
    
    @State private var times: [String: Date] = [
        "월": Date(),
        "화": Date(),
        "수": Date(),
        "목": Date(),
        "금": Date(),
        "토": Date(),
        "일": Date()
    ]
    
    let minutes = [1, 3, 5, 7, 10]
    let counts = [1, 2, 3, 4, 5]
    let daysOfWeek = ["월", "화", "수", "목", "금", "토", "일"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 상단 바
                HStack {
                    Spacer()
                    Text("루틴 등록")
                        .padding(.leading, 30)
                        .font(.regular18)
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.semibold24)
                    }
                    .frame(alignment: .trailing)
                }
                
                ScrollView {
                    VStack(alignment: .center, spacing: 20) {
                        // 이모지 입력
                        EmojiButton(
                            selectedEmoji: $selectedEmoji, // @State 변수를 Binding으로 전달
                            emojiButtonType: .routineEmoji
                        ) { selectedEmoji in
                            print("Selected Emoji: \(selectedEmoji)")
                        }
                        .frame(maxWidth: .infinity, minHeight: 90)
                        
                        // 첫번째 네모칸(제목, 요일, 시간)
                        VStack(alignment: .leading, spacing: 20) {
                            // 제목 입력 필드
                            RouzzleTextField(text: $title, placeholder: "제목을 입력해주세요")
                                .accentColor(Color("AccentColor"))
                            
                            // 반복 요일 섹션
                            HStack {
                                Text("반복 요일")
                                    .font(.semibold18)
                                Spacer()
                                // 매일 체크박스
                                HStack {
                                    Image(systemName: isDaily ? "checkmark.square" : "square")
                                    Text("매일")
                                        .font(.regular16)
                                }
                                .foregroundColor(isDaily ? .black : .gray)
                                .onTapGesture {
                                    isDaily.toggle()
                                    selectedDays = isDaily ? Set(daysOfWeek) : []
                                }
                            }
                            
                            // 요일 선택 버튼
                            HStack(spacing: 15) {
                                ForEach(daysOfWeek, id: \.self) { day in
                                    DayButton(day: day, isSelected: selectedDays.contains(day)) {
                                        if selectedDays.contains(day) {
                                            selectedDays.remove(day)
                                        } else {
                                            selectedDays.insert(day)
                                        }
                                        isDaily = selectedDays.count == daysOfWeek.count
                                    }
                                }
                            }
                            
                            Divider()
                                .padding(.vertical, 2)
                            
                            HStack {
                                Text("시작 시간")
                                    .font(.semibold18)
                                Spacer()
                                VStack {
                                    // Todo: 요일별 값이 다를 때 띄우기
                                    Text("(요일별 다름)")
                                        .font(.regular12)
                                        .foregroundColor(.gray)
                                    
                                    NavigationLink {
                                        RoutineSetTimeView(selectedDays: Array(selectedDays))
                                    } label: {
                                        HStack {
                                            Text(startTime, style: .time)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(Color.white)
                                                .clipShape(.rect(cornerRadius: 8))
                                        }
                                    }
                                    .disabled(selectedDays.isEmpty)
                                }
                            }
                        }
                        .padding()
                        .background(Color.fromRGB(r: 248, g: 247, b: 247))
                        .clipShape(.rect(cornerRadius: 20))
                        
                        // 두 번째 네모칸(알림설정)
                        VStack(alignment: .leading, spacing: 20) {
                            // 알림 설정 제목 및 스위치
                            HStack {
                                Text("루틴 시작 알림")
                                    .font(.semibold18)
                                Spacer()
                                Toggle(isOn: $isNotificationEnabled) {
                                    Text("")
                                }
                                .toggleStyle(SwitchToggleStyle(tint: Color(.accent)))
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
                                        
                                        Text("간격으로")
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
                                            Image(systemName: isOneAlarm ? "checkmark.square" : "square")
                                            Text("1회만")
                                                .font(.regular16)
                                        }
                                        .foregroundColor(isOneAlarm ? .black : .gray)
                                        .onTapGesture {
                                            isOneAlarm.toggle()
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.fromRGB(r: 248, g: 247, b: 247))
                        .cornerRadius(20)
                    }
                    .padding(.top, 20)
                }
                
                RouzzleButton(buttonType: .save, action: {
                    print("루틴 등록 버튼")
                    dismiss()
                })
                .background(Color.white)
            }
            .padding()
            .toolbar(.hidden, for: .tabBar)
        }
    }
    // 요일 선택 버튼
    private func dayButton(for day: String) -> some View {
        ZStack {
            Image(selectedDays.contains(day) ? "dayButtonOn" : "dayButtonOff")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text(day)
                .font(.regular16)
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
        .clipShape(.rect(cornerRadius: 10))
        .tint(.accent)
        .disabled(isDisabled)
    }
}

struct DayButton: View {
    let day: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                if isSelected {
                    Circle()
                        .strokeBorder(.stroke, lineWidth: 2)
                        .background(Circle().fill(Color.background))
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.1))
                }
                Text(day)
                    .foregroundColor(isSelected ? .black : .gray)
                    .font(.regular16)
            }
            .frame(width: 35, height: 35)
        }
    }
}

#Preview {
    NavigationStack {
        AddRoutineView()
    }
}
