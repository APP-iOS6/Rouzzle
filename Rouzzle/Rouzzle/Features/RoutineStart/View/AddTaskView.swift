//
//  AddTaskView.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/6/24.
//

import SwiftUI

struct AddTaskView: View {
    @State var isShowingAddTaskSheet: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Label("08:00 AM", systemImage: "clock")
                    .font(.regular16)
                    .foregroundStyle(Color.subHeadlineFontColor)
                    .padding(.top, 10)
                
                Image(.routineStart)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.top, 5)
                
                // 할일 리스트
                VStack(spacing: 10) {
                    TaskStatusPuzzle(taskStatus: .completed)
                    
                    TaskStatusPuzzle(taskStatus: .pending)
                        .shadow(color: .black.opacity(0.1), radius: 2)
                    
                    TaskStatusPuzzle(taskStatus: .pending)
                        .shadow(color: .black.opacity(0.1), radius: 2)
                }
                
                RouzzleButton(buttonType: .addTask) {
                    isShowingAddTaskSheet.toggle()
                }
                .padding(.horizontal, -16)
                
                HStack {
                    Text("추천 할 일")
                        .font(.bold18)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .padding(6)
                            .foregroundStyle(.white)
                            .background(
                                Circle()
                                    .frame(width: 30, height: 30)
                            )
                    }
                }
                .padding(.top, 30)
                
                // 추천 할 일 리스트
                VStack(spacing: 10) {
                    TaskStatusPuzzle(taskStatus: .recommend)
                    
                    TaskStatusPuzzle(taskStatus: .recommend)
                    
                    TaskStatusPuzzle(taskStatus: .recommend)
                }
                
                HStack(alignment: .bottom) {
                    Text("추천 세트")
                        .font(.bold18)
                    
                    Spacer()
                    
                    Text("테마별 하기 좋은 것들을 모아놨어요!")
                        .font(.regular12)
                        .foregroundStyle(Color.subHeadlineFontColor)
                }
                .padding(.top, 10)
                
                HStack(spacing: 14) {
                    ForEach(["아침", "오후", "저녁", "휴식"], id: \.self) { time in
                        NavigationLink {
                            // 세트 추천으로 이동
                        } label: {
                            Text(time)
                                .font(.semibold16)
                                .foregroundStyle(.black)
                                .frame(width: 82, height: 67)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.fromRGB(r: 239, g: 239, b: 239), lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(.top, 10)
            }
            .padding(.bottom, 10)
            .customNavigationBar(title: "☀️ 아침 루틴")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // 루틴 수정, 삭제 시트
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.semibold20)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddTaskView()
    }
}
