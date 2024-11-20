//
//  StatisticStore.swift
//  Rouzzle
//
//  Created by 김동경 on 11/18/24.
//

import Factory
import FirebaseFirestore
import SwiftUI
import Observation

enum CompletionState {
    case completed
    case halfCompleted
    case failed
}

class StatisticStore: ObservableObject {
    // @ObservationIgnored
    private let db = Firestore.firestore()
    
    // @ObservationIgnored
    private var listener: ListenerRegistration?
    
    @Published var completionData: [Date: [RoutineCompletion]] = [:]
    @Published var currentDate: Date = Date()
    
    @Published var currentMonth: Int = 0
    @Published var days: [DateValue] = [] // 1일~31일 데이터가 들어가는 배열
    @Published var daysPassed: Int = 0 // 선택된 달이 이번 달이면 달로부터 몇일 지났는지, 다른 달이면 달 일 수
    @Published var toastMessage: String? // 토스트 메시지 값
    @Published var isLoading: Bool = false // 로딩 상태를 나타내기 위해
    @Published var isShowingGuide: Bool = false // 퍼즐 가이드
    @Published var selectedTask: RoutineCompletion? // 날짜 퍼즐 클릭 시 보여줄 데이터
    // 선택된 달의 데이터만 들어갈 딕셔너리
    @Published var statisticData: [Date: [RoutineCompletion]] = [:]
    // 요약 데이터
    var summaryData: [String: [RoutineCompletion]] {
        let allCompletions = statisticData.values.flatMap { $0 }
        return Dictionary(grouping: allCompletions, by: { $0.routineId })
    }
    
    let koreanDays = ["월", "화", "수", "목", "금", "토", "일"]
    
    init() {
        print("StatisticStore init")
        fetchMonthCompletionData()
        extractDate()
    }
    
    /// 현재 선택된 날짜의의 데이터만 필터링하는 함수
    func filterCurrentMonthData() {
        guard let (start, end) = getMonthDateRange(self.currentDate) else {
            return
        }
        let filter = completionData.filter { key, _ in
            return key >= start && key <= end
        }
        statisticData = filter
    }
    
    /// Completion 데이터 리스너 걸기
    func fetchMonthCompletionData() {
        guard let dateRange = getMonthDateRange(self.currentDate) else {
            return
        }
        let userUid = Utils.getUserUUID()
        
        listener = db.collection("RoutineCompletion")
            .whereField("userId", isEqualTo: userUid)
            .whereField("date", isGreaterThan: dateRange.start)
            .whereField("date", isLessThan: dateRange.end)
            .addSnapshotListener { [weak self] querySnapshot, _ in
                print("리스너 탐")
                guard let snapshot = querySnapshot else {
                    self?.toastMessage = "통계 데이터 불러오기에 실패했습니다."
                    return
                }
                
                snapshot.documentChanges.forEach { diff in
                    switch diff.type {
                    case .added, .modified:
                        do {
                            let data = try diff.document.data(as: RoutineCompletion.self)
                            self?.updateCompletionData(data)
                        } catch {
                            
                        }
                    case .removed:
                        return
                    }
                }
            }
    }
    
    /// 새로운 Completion 데이터가 들어왔음
    func updateCompletionData(_ completion: RoutineCompletion) {
        let normalizedDate = completion.date.startOfDay()
        if var completions = self.completionData[normalizedDate] {
            if let index = completions.firstIndex(where: { $0.documentId == completion.documentId }) {
                // 기존 데이터를 업데이트
                completions[index] = completion
            } else {
                // 새로운 데이터를 추가
                completions.append(completion)
            }
            self.completionData[normalizedDate] = completions
        } else {
            // 새로운 날짜 키를 추가
            self.completionData[normalizedDate] = [completion]
        }
        filterCurrentMonthData()
    }
    
    /// 선택된 루틴이 한달 중 총 몇일인지
    func countMTTDays(_ targetWeekdays: Set<Int>) -> Int {
        let calendar = Calendar.current
        return days.filter { dayValue in
            let weekday = calendar.component(.weekday, from: dayValue.date)
            return targetWeekdays.contains(weekday) && dayValue.day != -1
        }.count
    }
    
    /// 해당 날짜에 선택된 루틴의 완성도 상태를 반환하는 함수
    func getDayCompleteState(_ date: Date, routineId: String) -> CompletionState {
        guard let completions = statisticData[date], let routine = completions.first(where: { $0.routineId == routineId }) else {
            return .failed
        }
        let totalTasks = routine.taskCompletions.count
        let completedTasks = routine.taskCompletions.filter { $0.isComplete }.count
        
        // 완료된 작업 수에 따라 상태 결정
        switch completedTasks {
        case totalTasks:
            return .completed
        case 1..<totalTasks:
            return .halfCompleted
        default:
            return .failed
        }
    }
    
    /// 달력에서 퍼즐날짜 클릭했을 때 selectedTask 값 데이터 넣어주기
    func puzzleTapped(_ date: Date, routineId: String) {
        guard let completions = statisticData[date], let routine = completions.first(where: { $0.routineId == routineId }) else {
            return
        }
        selectedTask = routine
    }
    
    deinit {
        self.listener?.remove()
    }
}

// 달력에 관련된 메서드
extension StatisticStore {
    
    // 사용자가 달력의 달을 움직였을 때 실행되는 함수
    @MainActor
    func moveMonth(direction: Int) {
        
        currentMonth += direction
        
        let calendar = Calendar.current
        
        if let newDate = calendar.date(byAdding: .month, value: currentMonth, to: Date()) {
            currentDate = newDate
        }
        
        extractDate()
    }
    
    func getDayColor(for index: Int) -> Color {
        switch index {
        case 6: return .red
        case 5: return .blue
        default: return .primary
        }
    }
    
    /// date1 과 date2 가 같은 날인지 비교하는 함수
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func extractDate() {
        let calendar = Calendar.current
        guard let month = calendar.date(byAdding: .month, value: currentMonth, to: Date()) else {
            return
        }
        
        currentDate = month
        var days = getMonthDates(for: currentDate)
        
        let firstWeekday = (calendar.component(.weekday, from: days.first?.date ?? Date()) + 5) % 7
        for _ in 0..<firstWeekday {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        let today = Date()
        
        if calendar.isDate(today, equalTo: currentDate, toGranularity: .month) {
            // 현재 월의 시작일 계산
            if let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today)) {
                // 시작일로부터 오늘까지의 일수 계산
                let components = calendar.dateComponents([.day], from: startOfMonth, to: today)
                daysPassed = (components.day ?? 0) + 1 // 오늘 날짜 포함
            }
        } else {
            // 현재 월이 실제 월과 다르면 daysPassed를 0으로 설정하거나 원하는 기본값으로 설정
            daysPassed = days.count
        }
        
        self.days = days
        filterCurrentMonthData()
    }
    
    /// 달마다 일수를 가져와 DateValue로 저장시켜 반환하는 함수
    private func getMonthDates(for date: Date) -> [DateValue] {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        var days: [DateValue] = []
        
        guard let firstDay = calendar.date(from: DateComponents(year: year, month: month, day: 1)), let range = calendar.range(of: .day, in: .month, for: firstDay) else {
            return []
        }
        
        for day in range {
            let date = calendar.date(from: DateComponents(year: year, month: month, day: day))!
            days.append(DateValue(day: day, date: date))
        }
        return days
    }
    
    private func getMonthDateRange(_ date: Date) -> (start: Date, end: Date)? {
        let calendar = Calendar.current
        guard let start = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: date)),
              let end = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: start) else {
            return nil
        }
        return (start, end)
    }
}
