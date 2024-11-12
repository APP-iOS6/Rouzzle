//
//  EditRoutineViewModel.swift
//  Rouzzle
//
//  Created by 김동경 on 11/11/24.
//

import Foundation
import Factory
import Observation

@Observable
class EditRoutineViewModel {
    var routine: Routine
    var tempdayStartTime: [Day: Date] {
        return routine.dayStartTime.toDayDateDictionary()
    }
    var isDaily: Bool = false
    
    init(routine: Routine) {
        self.routine = routine
    }
    
    //    func toggleDaily() {
    //        if isDaily {
    //            // 해제: 모든 요일 해제
    //            routine.dayStartTime.removeAll()
    //            isDaily = false
    //        } else {
    //            // 설정: 모든 요일 선택하고 현재 시간 설정
    //            let currentDate = Date()
    //            for day in Day.allCases {
    //                rselectedDateWithTime[day] = currentDate
    //            }
    //            isDaily = true
    //        }
    //    }
}
