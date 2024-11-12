//
//  SocialService.swift
//  Rouzzle
//
//  Created by 김정원 on 11/13/24.
//

import Foundation
import FirebaseFirestore

protocol SocialServiceType {
    /// 모든 루틴을 사용자별로 그룹화 한다.
    func fetchRoutinesGroupedByUser() async throws -> [String: [Routine]]
}

class SocialService: SocialServiceType {
    private let db = Firestore.firestore()
    
    func fetchRoutinesGroupedByUser() async throws -> [String: [Routine]] {
        
        let snapshot = try await db.collection("Routine").getDocuments()
        let routines = try snapshot.documents.compactMap { try $0.data(as: Routine.self) }
        print("루틴 \(routines)")
        // userid를 기준으로 루틴을 그룹화
        let groupedRoutines = Dictionary(grouping: routines, by: { $0.userId })
        
        return groupedRoutines
    }
}
