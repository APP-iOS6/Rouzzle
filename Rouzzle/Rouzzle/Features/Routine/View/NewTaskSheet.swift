//
//  NewTaskSheet.swift
//  Rouzzle
//
//  Created by 김동경 on 11/5/24.
//

import SwiftUI

struct NewTaskSheet: View {
    
    enum SheetType: Hashable {
        case task
        case time
    }
    
    @State private var sheetType: SheetType = .task
    @State private var text: String = ""
    @State private var hour: Int = 0
    @State private var min: Int = 0
    @State private var second: Int = 0
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
    @FocusState var focusField: SheetType?
    @Binding var detents: Set<PresentationDetent>
    
    var body: some View {
        VStack {
            switch sheetType {
            case .task:
                HStack {
                    TextField("추가할 할 일을 입력해 주세요.", text: $text)
                        .focused($focusField, equals: .task)
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "arrow.up")
                            .bold()
                            .padding(8)
                            .foregroundStyle(.white)
                            .background(.accent)
                            .clipShape(.circle)
                    }
                }
                HStack {
                    if hour == 0 && min == 0 && second == 0 {
                        Button {
                            withAnimation {
                                focusField = nil
                                detents = [.fraction(0.3)]
                            }
                            sheetType = .time
                        } label: {
                            HStack {
                                Image(systemName: "gauge.with.needle")
                                    .tint(.gray)
                                Text("지속 시간 없음")
                                    .foregroundStyle(.gray)
                            }
                        }
                    } else {
                        Image(systemName: "gauge.with.needle")
                            .tint(.accent)
                        HStack {
                            Button {
                                withAnimation {
                                    focusField = nil
                                    detents = [.fraction(0.3)]
                                }
                                sheetType = .time
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
                    }
                    Spacer()
                }
            case .time:
                CustomTimePickerView(
                    hour: hour,
                    min: min,
                    second: second
                ) {
                    withAnimation {
                        focusField = .task
                        detents = [.fraction(0.12)]
                    }
                    sheetType = .task
                } comfirm: { hour, min, second in
                    withAnimation {
                        focusField = .task
                        detents = [.fraction(0.12)]
                    }
                    self.hour = hour
                    self.min = min
                    self.second = second
                    sheetType = .task
                }
                
            }
        }
        .animation(.smooth, value: sheetType)
        .onAppear {
            focusField = .task
        }
        .padding()
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
    NewTaskSheet(detents: .constant([.fraction(0.12)]))
}
