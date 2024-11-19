//
//  RoutineListView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import SwiftUI
import SwiftData

struct RoutineListView: View {
    @Query private var routinesQuery: [RoutineItem]
    @Environment(\.modelContext) private var modelContext
    @State private var isShowingAddRoutineSheet: Bool = false
    @State private var currentQuote: String = ""
    @State private var selectedFilter: FilterOption = .today // 필터 상태 추가
    @State private var isShowingChallengeView: Bool = false //
    @State private var toast: ToastModel?

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
                            .frame(maxWidth: .infinity, minHeight: 50, alignment: .top)
                    }
                    
                    VStack(alignment: .leading) {
                        RoutineFilterToggle(selectedFilter: $selectedFilter)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                    
                    // 필터링된 루틴 목록 표시
                    ForEach(filteredRoutines()) { routine in
                        NavigationLink {
                            AddTaskView(store: RoutineStore(routineItem: routine)) { message in
                                toast = ToastModel(type: .success, message: message)
                            }
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
                    AddRoutineContainerView()
                }
            }
            .toastView(toast: $toast)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    PieceCounter(count: 9)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isShowingChallengeView.toggle()
                    }, label: {
                        HStack {
                            Image(systemName: "trophy.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.yellow)
                                .frame(width: 18, height: 18)
                            Text("챌린지")
                                .font(.medium16)
                                .foregroundColor(.black)
                        }
                        .frame(width: 90, height: 30)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white)
                                .shadow(color: .black.opacity(0.1), radius: 2)
                        )
                        
                    })
                }
            }
            .navigationDestination(isPresented: $isShowingChallengeView) {
                RouzzleChallengeView()
            }
        }
    }
    
    // 선택한 필터에 따라 루틴을 필터링하는 함수
    private func filteredRoutines() -> [RoutineItem] {
        let routines = Array(routinesQuery) // @Query 결과를 일반 배열로 변환
        
        if selectedFilter == .today {
            let todayWeekday = Calendar.current.component(.weekday, from: Date())
            return routines.filter { routine in
                // RoutineItem의 dayStartTime에 오늘의 요일이 포함된 경우 반환
                return routine.dayStartTime.keys.contains(todayWeekday)
            }
        } else {
            // "All" 선택 시 모든 루틴 반환
            return routines
        }
    }
}

#Preview {
    NavigationStack {
        RoutineListView()
            .modelContainer(SampleData.shared.modelContainer)
    }
}
