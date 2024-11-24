//
//  NewTaskSheetViewModel.swift
//  Rouzzle
//
//  Created by 김동경 on 11/7/24.
//

import Factory
import Foundation
import Observation

@Observable
final class NewTaskSheetViewModel {
    
    @ObservationIgnored
    @Injected(\.routineService) private var routineService
    
    init() {
        print("시트뷰모델")
    }
    
    var emoji: String?
    var text: String = ""
    var hour: Int = 0
    var min: Int = 0
    var second: Int = 0
    var errorMessage: String?
    var sheetType: SheetType = .task
}

enum SheetType: Hashable {
    case task
    case time
}
