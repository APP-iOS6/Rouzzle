//
//  EditRoutineView.swift
//  Rouzzle
//
//  Created by 이다영 on 11/7/24.
//

import SwiftUI

struct EditRoutineView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: EditRoutineViewModel
    @State private var draggedItem: TaskEditData?
    @State private var showEditIcon = true
    @State private var showDeleteIcon = false
    @State private var emoji: String? = "🧩"
    var createRoutine: Bool = false
    let completeeAction: (String) -> Void
    init(
        viewModel: EditRoutineViewModel,
        createRoutine: Bool = false,
        completeeAction: @escaping (String) -> Void = { _ in }
    ) {
        self.viewModel = viewModel
        self.createRoutine = createRoutine
        self.completeeAction = completeeAction
    }
    
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
                            viewModel.editRoutine.emoji = selectedEmoji
                        }
                        .frame(maxWidth: .infinity, minHeight: 90)
                        
                        EditRoutineBasicSettingView(viewModel: viewModel)
                        
                        EditRoutineNotificationView(viewModel: viewModel)
                        
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
                        
                        ForEach(viewModel.editRoutine.taskList, id: \.id) { task in
                            if showDeleteIcon {
                                TaskStatusRow(
                                    taskStatus: .pending,
                                    emojiText: task.emoji,
                                    title: task.title,
                                    timeInterval: task.timer,
                                    showEditIcon: .constant(false),
                                    showDeleteIcon: $showDeleteIcon) {
                                        if let task = viewModel.editRoutine.taskList.first(where: { $0.id == task.id }) {
                                            viewModel.deleteTasks.append(task)
                                        }
                                        viewModel.editRoutine.taskList.removeAll { $0.id == task.id }
                                    }
                            } else {
                                TaskStatusRow(
                                    taskStatus: .pending,
                                    emojiText: task.emoji,
                                    title: task.title,
                                    timeInterval: task.timer,
                                    showEditIcon: .constant(true),
                                    showDeleteIcon: $showDeleteIcon
                                )
                                .onDrag {
                                    draggedItem = task
                                    return NSItemProvider()
                                }
                                .onDrop(of: [.text], delegate: EditRoutineTaskDropDelegate(item: task, items: $viewModel.editRoutine.taskList, draggedItem: $draggedItem))
                            }
                        }
                        .padding(.horizontal, 4)
                        Spacer(minLength: 100)
                    }
                    .padding(.top, 20)
                }
                
                RouzzleButton(buttonType: .save, disabled: viewModel.tempdayStartTime.isEmpty, action: {
                    Task {
                        if createRoutine {
                            await viewModel.createRoutine(context: modelContext)
                        } else {
                            await viewModel.updateRoutine(context: modelContext)
                        }
                    }
                })
                .background(Color.white)
            }
            .onAppear {
                emoji = viewModel.routine.emoji
            }
            .overlay {
                if viewModel.loadState == .loading {
                    ProgressView()
                }
            }
            .onChange(of: viewModel.loadState, { _, new in
                if new == .completed {
                    completeeAction(viewModel.editRoutine.title)
                    dismiss()
                }
            })
            .padding()
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

struct EditRoutineBasicSettingView: View {
    @Bindable var viewModel: EditRoutineViewModel
    var body: some View {
        VStack(spacing: 20) {
            RouzzleTextField(text: $viewModel.editRoutine.title, placeholder: "제목을 입력해 주세요.")
                .font(.regular16)

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
                if !viewModel.tempdayStartTime.isEmpty {
                    VStack(spacing: 4) {
                        if let firstDay = viewModel.tempdayStartTime.sorted(by: { $0.key.rawValue < $1.key.rawValue }).first {
                            // 선택된 요일 중 가장 첫 번째 요일의 시간을 보여줄 거임
                            NavigationLink {
                                WeekSetTimeView(selectedDateWithTime: $viewModel.tempdayStartTime) { allTime in
                                    viewModel.selectedDayChangeDate(allTime)
                                }
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
        .animation(.smooth, value: viewModel.tempdayStartTime)
        .padding()
        .background(Color.fromRGB(r: 248, g: 247, b: 247))
        .clipShape(.rect(cornerRadius: 20)) // .cornerRadius 대신 clipShape 사용
    }
}

struct EditRoutineNotificationView: View {
    @Bindable var viewModel: EditRoutineViewModel
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
                        selection: $viewModel.editRoutine.interval
                    )
                    
                    Text("간격으로")
                        .foregroundStyle(isOneAlarm ? .gray : .primary)
                    
                    // 횟수 선택
                    CustomPicker2(
                        unit: "번",
                        isDisabled: isOneAlarm,
                        options: counts,
                        selection: $viewModel.editRoutine.repeatCount
                    )
                    
                    Text("알려드릴게요")
                        .foregroundStyle(isOneAlarm ? .gray : .primary)
                    
                    Spacer()
                }
            }
        }
        .onChange(of: viewModel.isNotificationEnabled, { _, newValue in
            if newValue {
                viewModel.editRoutine.repeatCount = 1
                viewModel.editRoutine.interval = 1
            } else {
                viewModel.editRoutine.repeatCount = nil
                viewModel.editRoutine.interval = nil
            }
        })
        .animation(.smooth, value: viewModel.isNotificationEnabled)
        .padding()
        .background(Color.fromRGB(r: 248, g: 247, b: 247))
        .clipShape(.rect(cornerRadius: 20))
    }
}

struct EditRoutineTaskDropDelegate: DropDelegate {
    let item: TaskEditData
    @Binding var items: [TaskEditData]
    @Binding var draggedItem: TaskEditData?
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedItem,
              draggedItem.id != item.id,
              let fromIndex = items.firstIndex(where: { $0.id == draggedItem.id }),
              let toIndex = items.firstIndex(where: { $0.id == item.id }) else { return }
        
        withAnimation {
            items.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
        }
    }
}

#Preview {
    NavigationStack {
        EditRoutineView(viewModel: .init(routine: RoutineItem.sampleData[0]))
    }
}
