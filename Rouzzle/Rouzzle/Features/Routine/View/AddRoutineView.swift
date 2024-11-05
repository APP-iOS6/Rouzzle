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
    
    var daysOfWeek = ["월", "화", "수", "목", "금", "토", "일"]

    var body: some View {
        VStack {
            VStack {
                // 이모지 입력
                Button(action: {
                    // 이모지 키보드
                }, label: {
                    ZStack {
                        Circle()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .frame(width: 70, height: 70)
                            .foregroundColor(Color("buttonColor"))
                        
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(Color("buttonColor"))
                    }
                })
                .padding(.vertical, 45)
            }
            
            // 첫번째 네모칸(제목, 요일, 시간)
            VStack(alignment: .leading, spacing: 20) {
                // 제목 입력 필드
                RouzzleTextField(text: $title, placeholder: "제목을 입력해주세요")
                    .accentColor(Color("buttonClolr"))
                
                // 반복 요일 섹션
                HStack {
                    Text("반복 요일")
                        .font(.headline)
                    Spacer()
                    // 매일 체크박스
                    HStack {
                        Button(action: {
                            isDaily.toggle()
                            selectedDays = isDaily ? Set(daysOfWeek) : []
                        }, label: {
                            Image(systemName: isDaily ? "checkmark.square" : "square")
                        })
                        .buttonStyle(PlainButtonStyle())
                        Text("매일")
                            .font(.body)
                    }
                    .foregroundColor(.gray)
                    
                }
                
                // 요일 선택 버튼
                HStack(spacing: 15) {
                    ForEach(daysOfWeek, id: \.self) { day in
                        dayButton(for: day)
                    }
                }
                
                Divider()
                    .padding(.vertical, 10)
                
                HStack {
                    Text("시작 시간")
                        .font(.headline)
                    Spacer()
                    DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(CompactDatePickerStyle())
                        .labelsHidden()
                        .frame(width: 100, height: 40)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                
//                Spacer()
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

#Preview {
    NavigationStack {
        AddRoutineView()
    }
}
