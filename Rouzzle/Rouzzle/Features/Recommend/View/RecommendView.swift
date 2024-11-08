//
//  RecommendView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import SwiftUI
import SwiftData
struct RecommendView: View {
    @Query private var routines: [RoutineItem]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack {
            Button {
                do {
                    try SwiftDataService.addRoutine(title: "아침", emoji: "☀️", dayStartTime: [1: .now], context: modelContext)
                } catch {
                    print("실패")
                }
            } label: {
                Text("모델 더미데이터 생성용")
            }
            List {
                ForEach(routines) { routine in
                    HStack {
                        Text(routine.emoji)
                        Text(routine.title)
                    }
                }
            }
        }
    }
}

#Preview {
    RecommendView()
}
