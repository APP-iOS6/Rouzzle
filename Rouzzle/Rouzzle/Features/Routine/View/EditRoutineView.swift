//
//  EditRoutineView.swift
//  Rouzzle
//
//  Created by 이다영 on 11/7/24.
//

import SwiftUI

struct EditRoutineView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var tasks = DummyTask.tasks
    @State private var draggedItem: DummyTask?
    @State private var showEditIcon = true
    @State private var showDeleteIcon = false
    
    @State private var title: String = ""
    @State private var selectedDays: Set<String> = []
    @State private var isDaily: Bool = false
    @State private var startTime: Date = Date()
    @State private var isNotificationEnabled: Bool = false
    @State private var isOneAlarm: Bool = false
    @State private var selectedMinute: Int = 2
    @State private var selectedCount: Int = 1
    @State private var emoji: String? = "🧩"
    
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
                    Text("루틴 수정")
                        .padding(.leading, 40)
                        .font(.regular18)
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.semibold24)
                    }
                    .frame(alignment: .trailing)
                    .padding(.trailing, 20)
                }
                
                ScrollView {
                    VStack(alignment: .center, spacing: 20) {
                        // 이모지 입력
                        EmojiButton(selectedEmoji: $emoji, emojiButtonType: .routineEmoji) { selectedEmoji in
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
                                    dayButton(for: day)
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
                                                .cornerRadius(8)
                                        }
                                    }
                                    .disabled(selectedDays.isEmpty)
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
                                        .font(.semibold18)
                                    
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
                        
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Text("목록 수정")
                                    .font(.semibold18)
                                    .padding(.leading, 14)
                                
                                Spacer()
                                
                                // 삭제 버튼
                                Button {
                                    showDeleteIcon.toggle()
                                } label: {
                                    // 삭제버튼 눌렸을 때, 목록이동이미지->삭제버튼
                                    Image(systemName: showDeleteIcon ? "arrow.up.arrow.down" : "trash")
                                        .foregroundColor(.gray)
                                }
                                .padding(.trailing, 14)
                            }
                            .padding(.top, 20)
                            VStack(spacing: 20) {
                                ForEach(tasks) { task in
                                    if showDeleteIcon {
                                        // 삭제
                                        TaskStatusRow(
                                            taskStatus: task.taskStatus,
                                            emojiText: task.emoji,
                                            title: task.title,
                                            showEditIcon: .constant(false),
                                            showDeleteIcon: $showDeleteIcon,
                                            onDelete: {
                                                tasks.removeAll { $0.id == task.id}
                                            }
                                        )
                                        // 순서 수정
                                    } else {
                                        TaskStatusRow(
                                            taskStatus: task.taskStatus,
                                            emojiText: task.emoji,
                                            title: task.title,
                                            showEditIcon: .constant(true),
                                            showDeleteIcon: $showDeleteIcon
                                        )
                                        .onDrag {
                                            draggedItem = task
                                            return NSItemProvider()
                                        }
                                        .onDrop(of: [.text],
                                                delegate: DropViewDelegate(item: task, items: $tasks, draggedItem: $draggedItem))
                                    }
                                }
                            }
                        }
                        Spacer(minLength: 100)
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

#Preview {
    NavigationStack {
        EditRoutineView()
    }
}
