//
//  AccountManagementView.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/15/24.
//

import SwiftUI
import SwiftData

struct AccountManagementView: View {
    @State private var isShowingDeleteAccountAlert: Bool = false
    @State private var isShowingDeleteRoutineAlert: Bool = false
    @State private var isShowingLogoutAlert: Bool = false
    @State private var isShowingLinkEmailSheet: Bool = false
    @State private var viewModel = AccountManagementViewModel()
    @State private var toast: ToastModel?
    @Environment(AuthStore.self) private var authStore
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ScrollView {
            HStack {
                Text("이메일")
                    .font(.semibold16)
                
                Spacer()
                
                if viewModel.isGuestUser {
                    Button {
                        isShowingLinkEmailSheet.toggle()
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
            .frame(minHeight: 45)
            
            Divider()
            
            Button {
                isShowingDeleteRoutineAlert.toggle()
            } label: {
                Text("루틴 초기화")
                    .font(.semibold16)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, minHeight: 45, alignment: .leading)
            }
            
            Divider()
            
            Button {
                isShowingLogoutAlert.toggle()
            } label: {
                HStack {
                    Text("로그아웃")
                        .font(.medium16)
                        .foregroundStyle(.red)
                }
                .frame(maxWidth: .infinity, minHeight: 45, alignment: .leading)
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
                .frame(maxWidth: .infinity, minHeight: 45, alignment: .leading)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .overlay {
            if authStore.loadState == .loading {
                ProgressView()
            }
        }
        .customNavigationBar(title: "계정 관리")
        .customAlert(isPresented: $isShowingLogoutAlert,
                     title: "로그아웃하시겠어요?",
                     message: "",
                     primaryButtonTitle: "로그아웃",
                     primaryAction: { authStore.logOut() })
        .customAlert(isPresented: $isShowingDeleteAccountAlert,
                     title: "정말 탈퇴하시겠어요?",
                     message: "탈퇴 버튼 선택 시, 계정은\n삭제되며 복구되지 않습니다.",
                     primaryButtonTitle: "탈퇴",
                     primaryAction: {
            authStore.deleteAccount()
            viewModel.deleteSwiftDataRoutines(context: modelContext)
        })
        .customAlert(isPresented: $isShowingDeleteRoutineAlert,
                     title: "모든 루틴을 초기화합니다",
                     message: "초기화 버튼 선택 시, 루틴 데이터는\n삭제되며 복구되지 않습니다.",
                     primaryButtonTitle: "초기화",
                     primaryAction: {
            Task {
                do {
                    try await viewModel.deleteFireStoreRoutines()
                    viewModel.deleteSwiftDataRoutines(context: modelContext)
                    toast = ToastModel(type: .success, message: "모든 루틴이 초기화되었습니다.")
                    print("✅ 모든 루틴 초기화 성공")
                }
            }
        })
        .fullScreenCover(isPresented: $isShowingLinkEmailSheet) {
            LinkEmailView { viewModel.updateUserStatus() }
        }
        .toastView(toast: $toast)
    }
}

#Preview {
    NavigationStack {
        AccountManagementView()
            .environment(AuthStore())
    }
}
