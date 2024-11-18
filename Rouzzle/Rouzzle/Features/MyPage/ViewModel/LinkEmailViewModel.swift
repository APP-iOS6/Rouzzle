//
//  LinkEmailViewModel.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/18/24.
//

import Foundation
import FirebaseAuth
import Factory
import AuthenticationServices
import Observation

@Observable
final class LinkEmailViewModel {
    @ObservationIgnored
    @Injected(\.authService) private var authService
    var currentNonce: String?
    
    var showErrorAlert: Bool = false
    var errorMessage: String = ""
    
    func googleLinkAction(dismiss: @escaping () -> Void) async {
        let result = await authService.signInWithGoogle(shouldLink: true)
        switch result {
        case .success(let userId):
            print("✅ 구글 계정 연동 성공: \(userId)")
            dismiss()
        case .failure(let error):
            print("⛔️ 구글 계정 연동 실패: \(error.localizedDescription)")
        }
    }
    
    func kakaoLinkAction(dismiss: @escaping () -> Void) async {
        let result = await authService.signInWithKakao(shouldLink: true)
        switch result {
        case .success(let userId):
            print("✅ 카카오 계정 연동 성공: \(userId)")
            dismiss()
        case .failure(let error):
            print("⛔️ 카카오 계정 연동 실패: \(error.localizedDescription)")
        }
    }
    
    func appleLinkAction(
        authorization: ASAuthorization,
        nonce: String,
        dismiss: @escaping () -> Void
    ) async {
        let result = await authService.signInWithApple(authorization, nonce: nonce, shouldLink: true)
        switch result {
        case .success(let userId):
            print("✅ 애플 계정 연동 성공: \(userId)")
            dismiss()
        case .failure(let error):
            print("⛔️ 애플 계정 연동 실패: \(error.localizedDescription)")
            handleLinkError(error)
        }
    }
    
    private func handleLinkError(_ error: Error) {
        if let authError = error as? AuthError, authError == .credentialAlreadyInUse {
            errorMessage = "이미 연동된 외부 계정입니다.\n다른 외부 계정을 이용하거나\n기존 연동한 계정을 탈퇴 후 이용해 주세요."
        } else {
            errorMessage = "연동에 실패했습니다. 다시 시도해주세요."
        }
        showErrorAlert = true
    }
}
