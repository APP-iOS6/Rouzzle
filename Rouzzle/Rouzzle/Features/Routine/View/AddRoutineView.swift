//
//  AddRoutineView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import SwiftUI

struct AddRoutineView: View {
    @State private var title: String = ""
    @State private var selectedDays: Set<String> = ["월", "화", "수", "목", "금"]
    @State private var isDaily: Bool = false
    @State private var startTime: Date = Date()
    
    var daysOfWeek = ["월", "화", "수", "목", "금", "토", "일"]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 제목 입력 필드
            RouzzleTextField(text: $title, placeholder: "제목을 입력해주세요")
            
            // 반복 요일 섹션
            HStack {
                Text("반복 요일")
                    .font(.headline)
                Spacer()
                Toggle("매일", isOn: $isDaily)
                    .labelsHidden()
            }
            .padding(.horizontal, 5)
            
            // 요일 선택 버튼
            HStack(spacing: 15) {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.body)
                        .frame(width: 30, height: 30)
                        .background(selectedDays.contains(day) ? Color.green.opacity(0.2) : Color(.systemGray6))
                        .foregroundColor(selectedDays.contains(day) ? .black : .gray)
                        .overlay(
                            Circle()
                                .stroke(selectedDays.contains(day) ? Color.green : Color.clear, lineWidth: 1)
                        )
                        .clipShape(Circle())
                        .onTapGesture {
                            if selectedDays.contains(day) {
                                selectedDays.remove(day)
                            } else {
                                selectedDays.insert(day)
                            }
                        }
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
            
            Spacer()
        }
        .padding()
        .background(Color.fromRGB(r: 248, g: 247, b: 247))
        .cornerRadius(20)
        .padding()
        .customNavigationBar(title: "루틴 등록")
    }
}

#Preview {
    NavigationStack {
        AddRoutineView()
    }
}
