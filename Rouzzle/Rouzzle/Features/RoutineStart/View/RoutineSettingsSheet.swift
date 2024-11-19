//
//  RoutineSettingsSheet.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/6/24.
//

import SwiftUI
import Factory

struct RoutineSettingsSheet: View {
    @ObservationIgnored
    @Injected(\.routineService) private var routineService
    
    @Environment(\.dismiss) private var dismiss
    @Binding var isShowingEditRoutineSheet: Bool
    var routineItem: RoutineItem
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack(spacing: 20) {
            Button {
                isShowingEditRoutineSheet = true
                dismiss()
            } label: {
                Text("수정하기")
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
            }
            
            Divider()
            
            Button {
                deleteRoutine()
            } label: {
                Text("삭제하기")
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
            }
            
            Divider()
            
            Button {
                dismiss()
            } label: {
                Text("취소")
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
            }
        }
        .font(.regular18)
        .padding(.horizontal, 16)
    }
    
    private func deleteRoutine() {
        do {
            try SwiftDataService.deleteRoutine(routine: routineItem, context: modelContext)
            dismiss()
        } catch {
            print("❌ 루틴 삭제 실패: \(error.localizedDescription)")
        }
    }
}

#Preview {
    RoutineSettingsSheet(isShowingEditRoutineSheet: .constant(false), routineItem: RoutineItem.sampleData[0])
}
