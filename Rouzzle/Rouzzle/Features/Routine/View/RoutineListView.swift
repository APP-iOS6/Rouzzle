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
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        Spacer().frame(height: 5)
                        
                        // BlurView로 텍스트 애니메이션 적용
                        BlurTextView(text: "끊임없이 남탓하고, 사고하지 말라", font: .bold18, startTime: 0.5)
                        
                        NavigationLink(destination: RouzzleChallengeView()) {
                            ZStack {
                                Image(.dailyChallenge)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: .infinity)
                                
                                Text("루즐 챌린지")
                                    .font(.semibold18)
                                    .foregroundColor(.black)
                                    .padding(.bottom, 20)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding()
                    }
                    
                    ForEach(routines) { routine in
                        NavigationLink {
                            AddTaskView(store: RoutineStore(routineItem: routine))
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
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    PieceCounter(count: 9)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        print("Settings tapped")
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title2)
                    }
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
