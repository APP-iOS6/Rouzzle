//
//  CalendarView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/13/24.
//

import SwiftUI

struct CalendarView: View {
    let calendarState: CalendarViewStateManager
    @Binding var isShowingGuide: Bool
    
    var body: some View {
        VStack(spacing: 35) {
            // 년월 표시 및 이동 버튼
            HStack {
                Text("월간 요약")
                    .font(.bold16)
                Image(systemName: "questionmark.circle")
                    .frame(width: 15, height: 15)
                    .foregroundStyle(Color.graymedium)
                    .onTapGesture {
                        isShowingGuide.toggle()
                    }
                Spacer()
                
                HStack(spacing: 8) {
                    Button {
                        Task {
                            await calendarState.moveMonth(direction: -1)
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.regular14)
                            .foregroundStyle(Color.gray)
                    }
                    .disabled(calendarState.isLoading)
                    
                    Text(calendarState.extraData()[1] + "년 " + calendarState.extraData()[0] + "월")
                        .font(.regular14)
                    
                    Button {
                        Task {
                            await calendarState.moveMonth(direction: 1)
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.regular14)
                            .foregroundStyle(Color.gray)
                    }
                    .disabled(calendarState.isLoading)
                }
            }
            
            // 요일 헤더 표시
            HStack(spacing: 0) {
                ForEach(Array(calendarState.koreanDays.enumerated()), id: \.element) { index, day in
                    Text(day)
                        .font(.medium12)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(calendarState.getDayColor(for: index))
                }
            }
            
            // 날짜 그리드 표시
            CalendarGridView(calendarState: calendarState)
            
            #if DEBUG
            Button("더미 데이터 로드") {
                calendarState.loadDummyData()
            }
            .padding()
            .background(Color.themeColor)
            .cornerRadius(10)
            #endif

        }
        .padding(.horizontal)
        .task {
            await calendarState.loadRoutineCompletions()
        }
        .onChange(of: calendarState.currentMonth) { _, _ in
            Task {
                await calendarState.loadRoutineCompletions()
            }
        }
    }
}

// MARK: - 캘린더 헤더 뷰
struct CalendarHeaderView: View {
    let calendarState: CalendarViewStateManager
    @Binding var isShowingGuide: Bool
    
    var body: some View {
        HStack {
            Text("월간 요약")
                .font(.bold16)
            Image(systemName: "questionmark.circle")
                .frame(width: 15, height: 15)
                .foregroundStyle(Color.graymedium)
                .onTapGesture {
                    isShowingGuide.toggle()
                }
            Spacer()
            
            HStack(spacing: 8) {
                Button {
                    Task {
                        await calendarState.moveMonth(direction: -1)
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.regular14)
                        .foregroundStyle(Color.gray)
                }
                .disabled(calendarState.isLoading)
                
                Text(calendarState.extraData()[1] + "년 " + calendarState.extraData()[0] + "월")
                    .font(.regular14)
                    .contentTransition(.numericText())
                
                Button {
                    Task {
                        await calendarState.moveMonth(direction: 1)
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.regular14)
                        .foregroundStyle(Color.gray)
                }
                .disabled(calendarState.isLoading)
            }
        }
    }
}

// MARK: - 월 네비게이션 뷰
struct MonthNavigationView: View {
    let calendarState: CalendarViewStateManager
    
    var body: some View {
        HStack(spacing: 8) {
            NavigationButton(
                direction: -1,
                calendarState: calendarState,
                icon: "chevron.left"
            )
            
            Text(calendarState.extraData()[1] + "년 " + calendarState.extraData()[0] + "월")
                .font(.regular14)
                .animation(nil, value: calendarState.currentMonth)
            
            NavigationButton(
                direction: 1,
                calendarState: calendarState,
                icon: "chevron.right"
            )
        }
    }
}

// MARK: - 네비게이션 버튼
struct NavigationButton: View {
    let direction: Int
    let calendarState: CalendarViewStateManager
    let icon: String
    
    var body: some View {
        Button {
            Task {
                await calendarState.moveMonth(direction: direction)
            }
        } label: {
            Image(systemName: icon)
                .font(.regular14)
                .foregroundStyle(Color.gray)
        }
        .disabled(calendarState.isLoading)
    }
}

// MARK: - 요일 헤더 뷰
struct CalendarWeekdayHeaderView: View {
    let calendarState: CalendarViewStateManager
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(calendarState.koreanDays.enumerated()), id: \.element) { index, day in
                Text(day)
                    .font(.medium12)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(calendarState.getDayColor(for: index))
            }
        }
    }
}

// MARK: - 캘린더 그리드 뷰
struct CalendarGridView: View {
    let calendarState: CalendarViewStateManager
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 5) {
            ForEach(calendarState.days) { value in
                if value.day != -1 {
                    CalendarDayView(value: value, calendarState: calendarState)
                        .id(value.id)
                } else {
                    Color.clear
                        .frame(height: 40)
                }
            }
        }
        .animation(.none, value: calendarState.days)
    }
}

// MARK: - 캘린더 일자 뷰
struct CalendarDayView: View {
    let value: DateValue
    let calendarState: CalendarViewStateManager
    
    var body: some View {
        ZStack {
            if let status = calendarState.getTaskStatus(for: value.date) {
                if status == .fullyComplete {
                    Image(systemName: "puzzlepiece.extension.fill")
                        .font(.system(size: 35))
                        .foregroundStyle(Color.accentColor)
                        .transition(.opacity)
                    Text("\(value.day)")
                        .font(.medium16)
                        .foregroundStyle(Color.white)
                        .frame(width: 35, height: 35)
                } else {
                    Image(systemName: "puzzlepiece.extension.fill")
                        .font(.system(size: 35))
                        .foregroundStyle(Color.partiallyCompletePuzzle)
                        .transition(.opacity)
                    Text("\(value.day)")
                        .font(.medium16)
                        .foregroundStyle(Color.primary)
                        .frame(width: 35, height: 35)
                }
            } else {
                Text("\(value.day)")
                    .font(.medium16)
                    .foregroundStyle(Color.primary)
                    .frame(width: 35, height: 35)
                    .background(
                        Circle()
                            .fill(calendarState.isSameDay(date1: value.date, date2: Date()) ? Color.gray.opacity(0.3) : Color.clear)
                    )
            }
        }
        .frame(height: 40)
    }
}

// MARK: - 퍼즐 조각 뷰
struct StatusPuzzlePiece: View {
    let day: Int
    let status: CalendarTaskStatus
    
    var body: some View {
        ZStack {
            Image(systemName: "puzzlepiece.extension.fill")
                .font(.system(size: 35))
                .foregroundStyle(status == .fullyComplete ? Color.accentColor : Color.partiallyCompletePuzzle)
            Text("\(day)")
                .font(.medium16)
                .foregroundStyle(status == .fullyComplete ? Color.white : Color.primary)
                .frame(width: 35, height: 35)
        }
    }
}

// MARK: - 일반 날짜 뷰
struct NormalDayView: View {
    let day: Int
    let date: Date
    let calendarState: CalendarViewStateManager
    
    var body: some View {
        Text("\(day)")
            .font(.medium16)
            .foregroundStyle(Color.primary)
            .frame(width: 35, height: 35)
            .background(
                Circle()
                    .fill(calendarState.isSameDay(date1: date, date2: Date()) ? Color.gray.opacity(0.3) : Color.clear)
            )
    }
}

// MARK: - 로딩 오버레이
struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.1)
                .ignoresSafeArea()
            ProgressView()
                .tint(.accentColor)
        }
    }
}

// MARK: - 더미 데이터 버튼
struct DummyDataButton: View {
    let calendarState: CalendarViewStateManager
    
    var body: some View {
        Button("더미 데이터 로드") {
            calendarState.loadDummyData()
        }
        .padding()
        .background(Color.themeColor)
        .cornerRadius(10)
    }
}
