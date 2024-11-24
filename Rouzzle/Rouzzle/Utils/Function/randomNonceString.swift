//
//  RandomNonceString.swift
//  Rouzzle
//
//  Created by 김동경 on 11/4/24.
//

import Foundation

// 로그인 요청 시 nonce(number used once)를 생성하는 함수.
// nonce는 재사용 공격(replay attack)을 방지하기 위해 사용됨. 클라이언트가 임의의 값을 생성하고 이를 서버에 전달하여, 동일한 인증 요청이 반복되지 않도록함.
func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0) // length 0보다 작으면 종료
    let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length

    while remainingLength > 0 {
        let rangeLen = min(remainingLength, charset.count)
        let rangeLow = charset.startIndex
        let rangeEnd = charset.index(rangeLow, offsetBy: rangeLen)
        let range = rangeLow..<rangeEnd
        let bytes = Array(charset[range])
        // swiftlint:disable:next compiler_protocol_init
        bytes.forEach { result.append(Character(extendedGraphemeClusterLiteral: $0)) }
        remainingLength -= rangeLen
    }
    
    return result
}
