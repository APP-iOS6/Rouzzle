//
//  AddRoutineView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import SwiftUI

struct AddRoutineView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: AddRoutineViewModel
    @State private var weekSetTimeView: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                ScrollView {
                    VStack(alignment: .center, spacing: 20) {
                        // 이모지 입력
                        EmojiButton(
                            selectedEmoji: $viewModel.selectedEmoji,
                            emojiButtonType: .routineEmoji
                        ) { selectedEmoji in
                            print("Selected Emoji: \(selectedEmoji)")
                        }
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity, minHeight: 90)
                        
                        RoutineBasicSettingView(viewModel: viewModel, weekSetTimeView: $weekSetTimeView)
                        
                        RoutineNotificationView(viewModel: viewModel)
                    }
                }
                
                RouzzleButton(buttonType: .next, disabled: viewModel.disabled, action: {
                    viewModel.getRecommendTask()
                    viewModel.step = .task
                })
                .animation(.smooth, value: viewModel.disabled)
            }
            .overlay {
                if viewModel.loadState == .loading {
                    ProgressView()
                }
            }
            .onChange(of: viewModel.loadState, { _, newValue in
                if newValue == .completed {
                    dismiss()
                }
            })
            .fullScreenCover(isPresented: $weekSetTimeView, content: {
                WeekSetTimeView(selectedDateWithTime: $viewModel.selectedDateWithTime) { allTime in
                    viewModel.selectedDayChangeDate(allTime)
                }
            })
            .padding(.horizontal)
            .toolbar(.hidden, for: .tabBar)
        }
    }
    // 요일 선택 버튼
    private func dayButton(for day: Day) -> some View {
        ZStack {
            Image(viewModel.isSelected(day) ? "dayButtonOn" : "dayButtonOff")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text(day.name)
                .font(.regular16)
                .foregroundColor(viewModel.isSelected(day) ? .black : .gray)
        }
        .onTapGesture {
            viewModel.toggleDay(day)
        }
    }
}

struct RoutineBasicSettingView: View {
    @Bindable var viewModel: AddRoutineViewModel
    @Binding var weekSetTimeView: Bool
    var body: some View {
        VStack(spacing: 20) {
            RouzzleTextField(text: $viewModel.title, placeholder: "제목을 입력해주세요")
            
            HStack {
                Text("반복 요일")
                    .font(.semibold18)
                Spacer()
                
                HStack {
                    Image(systemName: viewModel.isDaily ? "checkmark.square" : "square")
                    Text("매일")
                        .font(.regular16)
                }
                .foregroundColor(viewModel.isDaily ? .black : .gray)
                .onTapGesture {
                    viewModel.toggleDaily()
                }
            }
            
            // 반복 요일 선택 버튼
            HStack(spacing: 15) {
                ForEach(Day.allCases, id: \.self) { day in
                    DayButton(day: day.name, isSelected: viewModel.isSelected(day)) {
                        viewModel.toggleDay(day)
                    }
                }
            }
            
            Divider()
            
            HStack(alignment: .top) {
                Text("시작 시간")
                    .font(.semibold18)
                Spacer()
                if !viewModel.selectedDateWithTime.isEmpty {
                    VStack(spacing: 4) {
                        if let firstDay = viewModel.selectedDateWithTime.sorted(by: { $0.key.rawValue < $1.key.rawValue }).first {
                            // 선택된 요일 중 가장 첫 번째 요일의 시간을 보여줄 거임
                            Button {
                                weekSetTimeView.toggle()
                            } label: {
                                Text(firstDay.value, style: .time)
                                    .foregroundStyle(.black)
                                    .font(.regular18)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.white)
                                    .clipShape(.rect(cornerRadius: 8))
                            }
                        }
                        Text("(요일별로 다름)")
                            .font(.regular12)
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
        .animation(.smooth, value: viewModel.selectedDateWithTime)
        .padding()
        .background(Color.fromRGB(r: 248, g: 247, b: 247))
        .clipShape(.rect(cornerRadius: 20)) // .cornerRadius 대신 clipShape 사용
    }
}

struct RoutineNotificationView: View {
    @Bindable var viewModel: AddRoutineViewModel
    @State private var isOneAlarm: Bool = false
    let minutes = [1, 3, 5, 7, 10]
    let counts = [1, 2, 3, 4, 5]
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("루틴 시작 알림")
                    .font(.semibold18)
                Spacer()
                Toggle("", isOn: $viewModel.isNotificationEnabled)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: .accent))
            }
            
            if viewModel.isNotificationEnabled {
                Divider()
                
                // 알람 체크박스
                HStack(spacing: 10) {
                    Text("알림 빈도")
                        .font(.headline)
                    Image(systemName: isOneAlarm ? "checkmark.square" : "square")
                    Text("1회만")
                        .font(.regular16)
                        .foregroundStyle(isOneAlarm ? .black : .gray)
                    Spacer()
                }
                .onTapGesture {
                    isOneAlarm.toggle()
                }
                
                HStack(spacing: 10) {
                    // 분 선택
                    CustomPicker2(
                        unit: "분",
                        isDisabled: isOneAlarm,
                        options: minutes,
                        selection: $viewModel.interval
                    )
                    
                    Text("간격으로")
                        .foregroundStyle(isOneAlarm ? .gray : .primary)
                    
                    // 횟수 선택
                    CustomPicker2(
                        unit: "횟수",
                        isDisabled: isOneAlarm,
                        options: counts,
                        selection: $viewModel.repeatCount
                    )
                    
                    Text("알려드릴게요")
                        .foregroundStyle(isOneAlarm ? .gray : .primary)
                    
                    Spacer()
                }
            }
        }
        .onChange(of: viewModel.isNotificationEnabled, { _, newValue in
            if newValue {
                viewModel.repeatCount = 1
                viewModel.interval = 1
            } else {
                viewModel.repeatCount = nil
                viewModel.interval = nil
            }
        })
        .animation(.smooth, value: viewModel.isNotificationEnabled)
        .padding()
        .background(Color.fromRGB(r: 248, g: 247, b: 247))
        .clipShape(.rect(cornerRadius: 20))
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

struct CustomPicker2: View {
    let unit: String
    let isDisabled: Bool
    let options: [Int]
    @Binding var selection: Int?
    
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { value in
                Button {
                    selection = value
                } label: {
                    Text("\(value)\(unit)")
                }
            }
        } label: {
            Text("\(selection ?? 0)\(unit)")
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
        }
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
        AddRoutineView(viewModel: .init())
    }
}
