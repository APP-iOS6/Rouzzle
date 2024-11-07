//
//  NewTaskSheet.swift
//  Rouzzle
//
//  Created by 김동경 on 11/5/24.
//

import SwiftUI

struct NewTaskSheet: View {
    
    @State private var vm: NewTaskSheetViewModel = .init()
    @Environment(\.dismiss) private var dismiss
    @FocusState var focusField: SheetType?
    @Binding var detents: Set<PresentationDetent>
    var formattedTime: String {
        var components: [String] = []
        
        if vm.hour > 0 {
            components.append("\(vm.hour)시간")
        }
        if vm.min > 0 {
            components.append("\(vm.min)분")
        }
        if vm.second > 0 {
            components.append("\(vm.second)초")
        }
        
        return components.joined(separator: " ")
    }
   
    /// 모델링을 안해서 나중에 할일 모델 action에 넣어주면 됨
    let action: () -> Void
    
    var body: some View {
        VStack {
            switch vm.sheetType {
            case .task:
                TaskInputView(text: $vm.text, emoji: $vm.emoji, focusField: _focusField) {
                    if vm.text.isEmpty || vm.emoji?.isEmpty == nil {
                        withAnimation {
                            vm.errorMessage = "이모지와 할 일 모두 입력해 주세요."
                        }
                        return
                    }
                    action()
                    dismiss()
                }
                
                TimeSelectionView(
                    detents: $detents,
                    sheetType: $vm.sheetType,
                    hour: $vm.hour,
                    min: $vm.min,
                    second: $vm.second,
                    errorMessage: $vm.errorMessage,
                    focusField: _focusField
                )
                if vm.errorMessage != nil {
                    Text(vm.errorMessage ?? "")
                        .foregroundStyle(.red)
                }
                
            case .time:
                CustomTimePickerView(
                    hour: vm.hour,
                    min: vm.min,
                    second: vm.second
                ) {
                    withAnimation {
                        focusField = .task
                        detents = [.fraction(0.12)]
                    }
                    vm.sheetType = .task
                } comfirm: { hour, min, second in
                    withAnimation {
                        focusField = .task
                        detents = [.fraction(0.12)]
                    }
                    vm.hour = hour
                    vm.min = min
                    vm.second = second
                    vm.sheetType = .task
                }
                
            }
        }
        .animation(.smooth, value: vm.sheetType)
        .onAppear {
            focusField = .task
        }
        .padding()
    }
}

struct TaskInputView: View {
    @Binding var text: String
    @Binding var emoji: String?
    @FocusState var focusField: SheetType?
    var onAddTask: () -> Void
    var body: some View {
        HStack {
            EmojiButton(selectedEmoji: $emoji, emojiButtonType: .keyboard) { emoji in
                self.emoji = emoji
                focusField = .task
            }
            
            TextField("추가할 할 일을 입력해 주세요.", text: $text)
                .focused($focusField, equals: .task)
            
            Button(action: onAddTask) {
                Image(systemName: "arrow.up")
                    .bold()
                    .padding(8)
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .clipShape(Circle())
            }
        }
        .padding(.bottom, 8)
    }
}

struct TimeSelectionView: View {
    @Binding var detents: Set<PresentationDetent>
    @Binding var sheetType: SheetType
    @Binding var hour: Int
    @Binding var min: Int
    @Binding var second: Int
    @Binding var errorMessage: String?
    @FocusState var focusField: SheetType?
    
    var formattedTime: String {
        var components: [String] = []
        
        if hour > 0 {
            components.append("\(hour)시간")
        }
        if min > 0 {
            components.append("\(min)분")
        }
        if second > 0 {
            components.append("\(second)초")
        }
        
        return components.joined(separator: " ")
    }
    
    var body: some View {
        HStack {
            if hour == 0 && min == 0 && second == 0 {
                Button {
                    withAnimation {
                        focusField = nil
                        detents = [.fraction(0.3)]
                        sheetType = .time
                    }
                } label: {
                    HStack {
                        Image(systemName: "gauge.with.needle")
                            .tint(.gray)
                        Text("지속 시간 없음")
                            .foregroundColor(.gray)
                    }
                }
            } else {
                HStack {
                    Image(systemName: "gauge.with.needle")
                        .foregroundColor(.accentColor)
                    HStack {
                        Button {
                            withAnimation {
                                focusField = nil
                                detents = [.fraction(0.3)]
                                sheetType = .time
                            }
                        } label: {
                            Text(" \(formattedTime)")
                        }
                        
                        Button {
                            withAnimation {
                                self.hour = 0
                                self.min = 0
                                self.second = 0
                            }
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                    .modifier(ChipModifier())
                }
            }
            Spacer()
        }
        .padding(.bottom, 16)
    }
}

struct CustomTimePickerView: View {
    
    @State private var hour: Int = 0
    @State private var min: Int = 0
    @State private var second: Int = 0
    let cancel: () -> Void
    let comfirm: (Int, Int, Int) -> Void
    
    init(
        hour: Int = 0,
        min: Int = 0,
        second: Int = 0,
        cancel: @escaping () -> Void = {},
        comfirm: @escaping (Int, Int, Int) -> Void = {_, _, _ in}
    ) {
        self.hour = hour
        self.min = min
        self.second = second
        self.cancel = cancel
        self.comfirm = comfirm
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    cancel()
                } label: {
                    Text("취소")
                        .foregroundStyle(.basic)
                }
                
                Spacer()
                
                Button {
                    comfirm(hour, min, second)
                } label: {
                    Text("완료")
                        .foregroundStyle(.basic)
                }
            }
            
            HStack {
                Picker("", selection: $hour) {
                    ForEach(0...5, id: \.self) {
                        Text("\($0) 시간").tag($0)
                    }
                }
                .pickerStyle(.wheel)
                
                Picker("", selection: $min) {
                    ForEach(0...59, id: \.self) {
                        Text("\($0) 분").tag($0)
                    }
                }
                .pickerStyle(.wheel)
                
                Picker("", selection: $second) {
                    ForEach(0...59, id: \.self) {
                        Text("\($0) 초").tag($0)
                    }
                }
                .pickerStyle(.wheel)
                
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    NewTaskSheet(detents: .constant([.fraction(0.12)])) {
        
    }
}
