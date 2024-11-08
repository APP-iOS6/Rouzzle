//
//  AddTaskView.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/6/24.
//

import SwiftUI
import SwiftData

struct AddTaskView: View {
    @Bindable var routineItem: RoutineItem
    @Environment(\.modelContext) private var modelContext
    @State var isShowingAddTaskSheet: Bool = false
    @State var isShowingTimerView: Bool = false
    @State var isShowingRoutineSettingsSheet: Bool = false
    @State private var detents: Set<PresentationDetent> = [.fraction(0.12)]
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Label("08:00 AM", systemImage: "clock")
                        .font(.regular16)
                        .foregroundStyle(Color.subHeadlineFontColor)
                        .padding(.top, 10)
                    
                    Button {
                        isShowingTimerView.toggle()
                    } label: {
                        Image(.routineStart)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .padding(.top, 5)
                
                    ForEach(routineItem.taskList) { task in
                        TaskStatusPuzzle(task: task)
                    }
                    
                    HStack {
                        Text("추천 할 일")
                            .font(.bold18)
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.white)
                                .font(.caption)
                                .background(
                                    Circle()
                                        .fill(Color.subHeadlineFontColor)
                                )
                        }
                    }
                    .padding(.top, 30)
                    
                    HStack(alignment: .bottom) {
                        Text("추천 세트")
                            .font(.bold18)
                        
                        Spacer()
                        
                        Text("테마별 추천 할 일을 모아놨어요!")
                            .font(.regular12)
                            .foregroundStyle(Color.subHeadlineFontColor)
                    }
                    .padding(.top, 10)
                    
                    HStack(spacing: 14) {
                        ForEach(RoutineCategoryByTime.allCases, id: \.self) { category in
                            NavigationLink(destination: TimeBasedRecommendSetView(category: category)) {
                                Text(category.rawValue)
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
                .padding(.bottom, 50)
                .customNavigationBar(title: "☀️ 아침 루틴")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isShowingRoutineSettingsSheet.toggle()
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.semibold20)
                        }
                    }
                }
                .fullScreenCover(isPresented: $isShowingTimerView) {
                    RoutineStartView()
                }
                .sheet(isPresented: $isShowingAddTaskSheet) {
                    NewTaskSheet(detents: $detents) {
                        // 할 일 추가 버튼 로직
                    }
                    .presentationDetents(detents)
                }
                .sheet(isPresented: $isShowingRoutineSettingsSheet) {
                    RoutineSettingsSheet()
                        .presentationDetents([.fraction(0.25)])
                }
            }
            
            FloatingButton {
                isShowingAddTaskSheet.toggle()
            }
            .padding()
        }
    }
}

//#Preview {
//    NavigationStack {
//        AddTaskView()
//    }
//}
