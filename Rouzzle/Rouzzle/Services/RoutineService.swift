//
//  RoutineService.swift
//  Rouzzle
//
//  Created by 김동경 on 11/6/24.
//

import Foundation
import FirebaseFirestore

protocol RoutineServiceType {
    /// 모든 루틴 데이터를 가져오는 함수
    func getAllRoutines() async throws -> [Routine]
    /// 루틴 컬렉션에 루틴 데이터를 추가하는 함수
    func addRoutine(_ routine: Routine) async -> Result<Routine, DBError>
    /// 루틴 컬렉션에 루틴 데이터를 삭제하는 함수
    func removeRoutine(_ routine: Routine) async -> Result<Void, DBError>
    /// 루틴 컴플리션 컬렉션에 루틴 데이터를 삭제하는 함수
    func removeRoutineCompletions(for routineId: String) async -> Result<Void, DBError>
    /// 루틴에 할 일을 추가하거나 삭제하거나 업데이트하는 함수
    func updateRoutine(_ routine: Routine) async -> Result<Void, DBError>
    /// 루틴 완료 상태 저장 함수
    func updateRoutineCompletion(_ completion: RoutineCompletion) async -> Result<Void, DBError>
    /// 특정 날짜의 모든 루틴 완료 상태 조회 함수
    func getRoutineCompletions(for date: Date) async -> Result<[RoutineCompletion], DBError>
    /// 내가 생성한 루틴과 오늘 루틴 완료 정보를 가져오는 함수
    func getMyRoutineInfo(_ userId: String) async -> Result<[RoutineWithCompletion], DBError>
}

class RoutineService: RoutineServiceType {
    private let db = Firestore.firestore()
    
    func getAllRoutines() async throws -> [Routine] {
        do {
            let snapshot = try await db.collection("Routine").getDocuments()
            let routines = try snapshot.documents.map { document in
                try document.data(as: Routine.self)
            }
            return routines
        } catch {
            throw DBError.firebaseError(error)
        }
    }
    
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
    
    func removeRoutineCompletions(for routineId: String) async -> Result<Void, DBError> {
        do {
            // RoutineCompletion 컬렉션에서 routineId로 문서 검색
            let snapshot = try await db.collection("RoutineCompletion")
                .whereField("routineId", isEqualTo: routineId)
                .getDocuments()
            
            // 각 문서를 삭제
            for document in snapshot.documents {
                try await document.reference.delete()
            }
            
            print("✅ 모든 RoutineCompletion 삭제 성공")
            return .success(())
        } catch {
            print("❌ RoutineCompletion 삭제 실패: \(error.localizedDescription)")
            return .failure(.firebaseError(error))
        }
    }
    
    func updateRoutine(_ routine: Routine) async -> Result<Void, DBError> {
        do {
            guard let routineId = routine.documentId else {
                return .failure(DBError.documenetIdError)
            }
            let routineEncode = try Firestore.Encoder().encode(routine)
            try await self.db.collection("Routine").document(routineId).setData(routineEncode)
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
    
    func getMyRoutineInfo(_ userId: String) async -> Result<[RoutineWithCompletion], DBError> {
        do {
            var routineWithCompletion: [RoutineWithCompletion] = []
            let documents = try await db.collection("Routine").whereField("userId", isEqualTo: userId).getDocuments().documents
            let routines = try documents.compactMap { try $0.data(as: Routine.self) }
            // 일단 내가 가지고 있는 루틴 다 가져오기 -> 루틴 돌면서 오늘 completion 데이터 가져오기
            print("내루틴들 \(routines.count)")
            for routine in routines {
                let documentId = "\(Date().formattedDateToString)_\(routine.documentId ?? "")"
                let documentSnapshot = try await db.collection("RoutineCompletion").document(documentId).getDocument()
                if documentSnapshot.exists {
                      let completion = try documentSnapshot.data(as: RoutineCompletion.self)
                      routineWithCompletion.append(RoutineWithCompletion(routine: routine, completion: completion))
                  } else {
                      // 문서가 존재하지 않을 경우의 처리 로직
                      // 예: 기본값 할당 또는 생략
                      let completion = RoutineCompletion(routineId: routine.documentId ?? "", userId: routine.userId, date: Date(), taskCompletions: routine.routineTask.map { $0.toTaskCompletion() })
                      routineWithCompletion.append(RoutineWithCompletion(routine: routine, completion: completion))
                  }
            }
            return .success(routineWithCompletion)
        } catch {
            return .failure(.firebaseError(error))
        }
    }
}
