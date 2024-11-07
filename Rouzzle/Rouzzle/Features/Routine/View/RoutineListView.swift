//
//  RoutineListView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import SwiftUI

struct RoutineListView: View {
    @State var isShowingAddRoutineSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Label {
                        Text("0")
                            .font(.regular16)
                            .foregroundColor(.black) // 텍스트를 검정색으로 설정
                    } icon: {
                        Image(systemName: "puzzlepiece.fill")
                            .foregroundStyle(.accent)
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.gray.opacity(0.3), radius: 1)
                    )
                    Spacer()
                    Button {
                        isShowingAddRoutineSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
                .padding()
                
                Text("끊임없이 남탓하고, 사고하지 말라")
                    .font(.bold18)
                
                ZStack {
                    Image(.dailyChallenge)
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .aspectRatio(contentMode: .fit)
                    Text("24일 루즐 챌린지")
                        .font(.semibold18)
                        .offset(y: -7)
                }
                .padding()
                
                NavigationLink {
                    AddTaskView()
                } label: {
                    RoutineStatusPuzzle(status: .pending)
                        .padding(.horizontal)
                }
                
                NavigationLink {
                    AddTaskView()
                } label: {
                    RoutineStatusPuzzle(status: .completed, emojiText: "☀️", routineTitle: "점심 루틴")
                        .padding(.horizontal)
                }
                
                Image(.requestRoutine)
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal)
                
                Spacer()
                
                // Text("Hello, World!")
            }
            .fullScreenCover(isPresented: $isShowingAddRoutineSheet) {
                AddRoutineView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        RoutineListView()
    }
}
