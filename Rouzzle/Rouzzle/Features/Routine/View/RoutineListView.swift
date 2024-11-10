//
//  RoutineListView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import SwiftUI
import SwiftData

struct RoutineListView: View {
    @Query private var routines: [RoutineItem]
    @Environment(\.modelContext) private var modelContext
    @State var isShowingAddRoutineSheet: Bool = false
//    @State var dataChanged: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
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

                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.title)
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
                    
                    ForEach(routines) { routine in
                        NavigationLink {
                            AddTaskView(routineItem: routine)
                        } label: {
                            RoutineStatusPuzzle(routineItem: routine)
                                .padding(.horizontal)
                        }
                    }
                    .id(routines)
                    
                    Image(.requestRoutine)
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal)
                    
                    Spacer()
                }
                
                FloatingButton(action: {
                    isShowingAddRoutineSheet.toggle()
                })
                .padding()
                .fullScreenCover(isPresented: $isShowingAddRoutineSheet) {
                    AddRoutineView()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RoutineListView()
            .modelContainer(SampleData.shared.modelContainer)
    }
}
