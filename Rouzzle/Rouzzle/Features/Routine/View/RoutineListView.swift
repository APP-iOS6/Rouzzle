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
    @State private var currentQuote: String = ""

    init() {
        // 초기 명언 설정
        _currentQuote = State(initialValue: QuotesProvider.randomQuote())
    }

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        Spacer().frame(height: 5)
                        
                        // 랜덤 명언 텍스트 애니메이션
                        TypeWriterTextView(text: $currentQuote, font: .bold18, animationDelay: 0.05)
                        
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
                    
                    Image(.requestRoutine)
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal)
                    
                    Spacer()
                }
                .refreshable {
                    // 새로고침 시 랜덤 명언 선택
                    currentQuote = QuotesProvider.randomQuote()
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
