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
    func addRoutine(_ routine: Routine) async -> Result<Routine, DBError>
    /// 루틴 컬렉션에 루틴 데이터를 삭제하는 함수
    func removeRoutine(_ routine: Routine) async -> Result<Void, DBError>
    /// 루틴에 할 일을 추가하거나 삭제하거나 업데이트하는 함수
    func updateRoutine(_ routine: Routine) async -> Result<Void, DBError>
    /// 루틴 완료 상태 저장 함수
    func updateRoutineCompletion(_ completion: RoutineCompletion) async -> Result<Void, DBError>
    /// 특정 날짜의 모든 루틴 완료 상태 조회 함수
    func getRoutineCompletions(for date: Date) async -> Result<[RoutineCompletion], DBError>
}

class RoutineService: RoutineServiceType {
    private let db = Firestore.firestore()
    
    func addRoutine(_ routine: Routine) async -> Result<Routine, DBError> {
        do {
            let routineEncode = try Firestore.Encoder().encode(routine)
            let doc = try await self.db.collection("Routine").addDocument(data: routineEncode)
            var routine = routine
            routine.documentId = doc.documentID
            return .success(routine)
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
    
    func updateRoutineCompletion(_ completion: RoutineCompletion) async -> Result<Void, DBError> {
        do {
            let encodedData = try Firestore.Encoder().encode(completion)
            let dateString = completion.date.formatted(date: .numeric, time: .omitted)
            let documentId = "\(completion.routineId)_\(dateString)"
            
            print("🔵 루틴 완료를 Firebase에 저장")
            print("📝 Document ID: \(documentId)")
            print("📅 Date: \(dateString)")
            print("✅ 완료 상태: \(completion.isCompleted)")
            print("📋 Tasks: \(completion.taskCompletions.count)")
            
            try await db.collection("RoutineCompletion")
                .document(documentId)
                .setData(encodedData)
            
            print("✨ Firebase에 성공적으로 저장")
            return .success(())
        } catch {
            print("❌ Firebase에 저장하지 못했습니다.: \(error.localizedDescription)")
            return .failure(.firebaseError(error))
        }
    }
    
    func getRoutineCompletions(for date: Date) async -> Result<[RoutineCompletion], DBError> {
        do {
            let dateString = date.formatted(date: .numeric, time: .omitted)
            let snapshot = try await db.collection("RoutineCompletion")
                .whereField("date", isEqualTo: dateString)
                .getDocuments()
            
            let completions = try snapshot.documents.map { doc in
                try doc.data(as: RoutineCompletion.self)
            }
            return .success(completions)
        } catch {
            return .failure(.firebaseError(error))
        }
    }
}
