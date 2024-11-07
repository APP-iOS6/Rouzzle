//
//  EditRoutineView.swift
//  Rouzzle
//
//  Created by 이다영 on 11/7/24.
//

import SwiftUI

struct EditRoutineView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("루틴 수정 뷰")
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.semibold24)
                }
                .padding(.trailing, 20)
            }
            
            Spacer()
        }
    }
}

#Preview {
    EditRoutineView()
}
