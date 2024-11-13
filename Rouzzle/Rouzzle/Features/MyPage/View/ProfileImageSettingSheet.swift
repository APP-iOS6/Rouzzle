//
//  ProfileImageSettingSheet.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/13/24.
//

import SwiftUI

struct ProfileImageSettingSheet: View {
    @Environment(\.dismiss) private var dismiss
    let editAction: () -> Void
    let deleteAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Button {
                dismiss()
                editAction()
            } label: {
                Text("사진 편집하기")
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
            }
            
            Divider()
            
            Button {
                dismiss()
                deleteAction()
            } label: {
                Text("사진 삭제하기")
                    .foregroundStyle(.black)
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
}

#Preview {
    ProfileImageSettingSheet(editAction: {}, deleteAction: {})
}
