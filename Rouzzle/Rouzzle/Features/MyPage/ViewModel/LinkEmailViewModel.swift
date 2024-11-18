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

final class LinkEmailViewModel {
    @ObservationIgnored
    @Injected(\.authService) private var authService
    var currentNonce: String?
    
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
        }
    }
}
