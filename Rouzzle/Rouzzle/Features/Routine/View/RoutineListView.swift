//
//  RoutineListView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import SwiftUI
import SwiftData

enum NavigationDestination: Hashable {
    case addTaskView
    case routineCompleteView
}

struct RoutineListView: View {
    @Query private var routinesQuery: [RoutineItem]
    @Environment(\.modelContext) private var modelContext
    @State private var isShowingAddRoutineSheet: Bool = false
    @State private var currentQuote: String = ""
    @State private var selectedFilter: FilterOption = .today
    @State private var isShowingChallengeView: Bool = false
    @State private var toast: ToastModel?
    @State private var path = NavigationPath() // NavigationPath 추가
    @Environment(RoutineStore.self) private var routineStore
    var filterRoutineItem: [RoutineItem] {
        if selectedFilter == .today {
            let todayWeekday = Calendar.current.component(.weekday, from: Date())
            return routinesQuery.filter { routine in
                return routine.dayStartTime.keys.contains(todayWeekday)
            }
        } else {
            return routinesQuery
        }
    }
    
    init() {
        _currentQuote = State(initialValue: QuotesProvider.randomQuote())
    }
    
    var body: some View {
        NavigationStack(path: $path) { // NavigationStack에 path 바인딩
            ScrollView {
                VStack(spacing: 20) {
                    Spacer().frame(height: 5)
                    TypeWriterTextView(text: $currentQuote, font: .bold18, animationDelay: 0.05)
                        .frame(maxWidth: .infinity, minHeight: 50, alignment: .top)
                }
                
                // 토글, 루틴 등록 버튼
                HStack {
                    RoutineFilterToggle(selectedFilter: $selectedFilter)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button {
                        isShowingAddRoutineSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title)
                    }
                    
                }
                .padding(.horizontal)
                .padding(.bottom, 5)
                
                // 루틴 목록
                ForEach(filterRoutineItem, id: \.id) { routine in
                    Button {
                        routineStore.selectedRoutineItem(routine)
                        path.append(NavigationDestination.addTaskView)
                    } label: {
                        let status = returnRoutineStatus(routine.taskList)
                        ZStack {
                            status.image
                                .resizable()
                                .frame(maxWidth: .infinity)
                                .aspectRatio(370 / 137, contentMode: .fit)
                            
                            HStack {
                                Text("\(routine.emoji)")
                                    .font(.bold40)
                                    .padding(.trailing, 10)
                                    .padding(.bottom, 7)
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(routine.title)
                                        .font(.semibold18)
                                        .foregroundStyle(.black)
                                        .bold()
                                        .strikethrough(status == .completed)
                                    
                                    Text(inProgressCount(routine.taskList))
                                        .font(.regular14)
                                        .foregroundStyle(Color.subHeadlineFontColor)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 5) {
                                    HStack(spacing: 5) {
                                        Image(systemName: getAlarmImageName(routine)) // 알림 이미지 동적으로 업데이트
                                        Text(todayStartTime(routine.dayStartTime))
                                    }
                                    .font(.regular14)
                                    Text(convertDaysToString(days: routine.dayStartTime.keys.sorted()))
                                        .font(.regular14)
                                }
                                .foregroundStyle(Color.subHeadlineFontColor)
                            }
                            .padding(.horizontal, 20)
                            .offset(y: -7)
                        }
                        .padding(.horizontal)
                        .opacity(status == .pending ? 1 : 0.6)
                    }
                }
                
                // 루틴을 등록해 주세요 버튼
                Button {
                    isShowingAddRoutineSheet.toggle()
                } label: {
                    Image(.requestRoutine)
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal)
                }
            }
            .refreshable {
                currentQuote = QuotesProvider.randomQuote()
            }
            .fullScreenCover(isPresented: $isShowingAddRoutineSheet) {
                AddRoutineContainerView()
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
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .addTaskView:
                    AddTaskView(
                        path: $path,
                        completeAction: { message in
                            toast = ToastModel(type: .success, message: message)
                        }
                    )
                case .routineCompleteView:
                    RoutineCompleteView(
                        path: $path
                    )
                }
            }
            .navigationDestination(isPresented: $isShowingChallengeView) {
                RouzzleChallengeView()
            }
        }
    }
}

#Preview {
    RoutineListView()
        .modelContainer(SampleData.shared.modelContainer)
}
