//
//  RoutineSettingsSheet.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/6/24.
//

import SwiftUI

struct RoutineSettingsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State var isShowingEditRoutineSheet: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Button {
                isShowingEditRoutineSheet.toggle()
            } label: {
                Text("수정하기")
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
            }
            
            Divider()
            
            Button {
                
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
        .fullScreenCover(isPresented: $isShowingEditRoutineSheet) {
            EditRoutineView()
        }
    }
}

#Preview {
    RoutineSettingsSheet()
}
