//
//  sha256.swift
//  Rouzzle
//
//  Created by 김동경 on 11/4/24.
//

import Foundation
import CryptoKit

// 생성된 nonce를 SHA-256 해시로 변환함
// Apple은 클라이언트에서 생성된 nonce의 해시 값을 서버로 전달함, Apple ID 서버에서 이를 검증할 수 있도록 요구함. 해시를 사용하면 원본 nonce를 노출하지 않고도 검증할 수 있어 보안이 강화됨?
func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
    }.joined()
    
    return hashString
}
