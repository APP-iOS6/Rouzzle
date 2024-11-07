//
//  RoutineService.swift
//  Rouzzle
//
//  Created by 김동경 on 11/6/24.
//

import Foundation
import FirebaseFirestore

/*
 RoutineService 흐름
 1. 루틴 생성 흐름 - Routine 컬렉션에 Routine 데이터 생성 -> 루틴 데이터에서 day가 오늘에 포함된다면 RoutineCompletion에 오늘 날짜에 대한 데이터 생성, 그렇지 않다면 RoutineCompletion 데이터 생성 x
 2. 루틴 편집 흐름 - Routine 컬렉션에 Routine 데이터 수정 - > 해당 루틴id가 같고 오늘 날짜와 같은 RoutineCompletion 데이터 수정
 3. 루틴 삭제 흐름 - Routine 컬렉션에 Routine 데이터 삭제
 4. 유저 접속 흐름 - userId 와 내 uid 가 같은 Routine 접근 -> RoutineId(documentId), userId == 내 uid, Date 가 오늘 조건을 쿼리로 데이터 있는지 없는지 검색 -> RoutineCompletion 데이터 있다면 가져오기, 없다면 해당 루틴에 오늘이 포함되어 있다면 생성 후 가져오기.                            
 */

protocol RoutineServiceType {
    func addRoutine(_ routine: Routine)
    func checkTodayRoutineCompletion(userUid: String)
}

class RoutineService {
    
    func addRoutine(_ routine: Routine) {
        
    }
    
    func addRoutineCompletion(_ routine: Routine) {
        
    }
    
    func checkTodayRoutineCompletion(userUid: String) {
        
    }
}
