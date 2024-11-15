//
//  AccountManagementView.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/15/24.
//

import SwiftUI

struct AccountManagementView: View {
    @State private var isShowingDeleteAccountAlert: Bool = false
    @State private var isShowingDeleteRoutineAlert: Bool = false
    @State private var viewModel = AccountManagementViewModel()
    @Environment(AuthStore.self) private var authStore

    var body: some View {
        ScrollView {
            HStack {
                Text("이메일")
                    .font(.semibold16)
                
                Spacer()
                
                if viewModel.isGuestUser {
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            Text("이메일 연동하기")
                            Image(systemName: "chevron.right")
                        }
                    }
                } else {
                    Text(viewModel.userEmail)
                }
            }
            .foregroundStyle(.black)
            .font(.regular16)
            .frame(width: 370, height: 45)
            
            Divider()
            
            Button {
                isShowingDeleteRoutineAlert.toggle()
            } label: {
                Text("루틴 초기화")
                    .font(.semibold16)
                    .foregroundStyle(.black)
                    .frame(width: 370, height: 45, alignment: .leading)
            }
            
            Divider()
            
            Button {
                isShowingDeleteAccountAlert.toggle()
            } label: {
                HStack {
                    Text("계정탈퇴")
                        .font(.medium16)
                        .foregroundStyle(.red)
                }
                .frame(width: 370, height: 45, alignment: .leading)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .customNavigationBar(title: "계정 관리")
        .customAlert(isPresented: $isShowingDeleteAccountAlert,
                     title: "정말 탈퇴하시겠어요?",
                     message: "탈퇴 버튼 선택 시, 계정은\n삭제되며 복구되지 않습니다.",
                     primaryButtonTitle: "탈퇴",
                     primaryAction: { print("탈퇴 버튼 눌림")
            authStore.deleteAccount() })
        .customAlert(isPresented: $isShowingDeleteRoutineAlert,
                     title: "모든 루틴을 초기화합니다",
                     message: "초기화 버튼 선택 시, 루틴 데이터는\n삭제되며 복구되지 않습니다.",
                     primaryButtonTitle: "초기화",
                     primaryAction: { /* 로직 추가 예정 */ })
    }
}

#Preview {
    NavigationStack {
        AccountManagementView()
            .environment(AuthStore())
    }
}
