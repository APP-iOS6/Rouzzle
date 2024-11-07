//
//  RoutineService.swift
//  Rouzzle
//
//  Created by 김동경 on 11/6/24.
//

import Foundation
import FirebaseFirestore

protocol RoutineServiceType {
    /// 루틴 컬렉션에 루틴 데이터를 추가하는 함수
    func addRoutine(_ routine: Routine) async -> Result<Void, DBError>
    /// 루틴 컬렉션에 루틴 데이터를 삭제하는 함수
    func removeRoutine(_ routine: Routine) async -> Result<Void, DBError>
    /// 루틴에 할 일을 추가하거나 삭제하거나 업데이트하는 함수
    func updateRoutine(_ routine: Routine) async -> Result<Void, DBError>
    
}

class RoutineService: RoutineServiceType {
    
    private let db = Firestore.firestore()
    
    func addRoutine(_ routine: Routine) async -> Result<Void, DBError> {
        do {
            let routineEncode = try Firestore.Encoder().encode(routine)
            try await self.db.collection("Routine").addDocument(data: routineEncode)
            return .success(())
        } catch {
            return .failure(DBError.firebaseError(error))
        }
    }
    
    func removeRoutine(_ routine: Routine) async -> Result<Void, DBError> {
        do {
            guard let routineId = routine.documentId else {
                return .failure(DBError.documenetIdError)
            }
            try await self.db.collection("Routine").document(routineId).delete()
            return .success(())
        } catch {
            return .failure(DBError.firebaseError(error))
        }
    }
    
    func updateRoutine(_ routine: Routine) async -> Result<Void, DBError> {
        do {
            guard let routineId = routine.documentId else {
                return .failure(DBError.documenetIdError)
            }
            let routineEncode = try Firestore.Encoder().encode(routine)
            try await self.db.collection("Routine").document(routineId).setData(routineEncode, merge: true)
            return .success(())
        } catch {
            return .failure(DBError.firebaseError(error))
        }
    }
}
