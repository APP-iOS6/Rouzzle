//
//  FAQViewModel.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/15/24.
//

import SwiftUI

class FAQViewModel {
    let toAddress: String = "rouzzle.dev@gmail.com" // 개발자 이메일
    let subject: String = "문의하기" // 제목
    var body: String {"""
           어떤 문제를 겪고 계신지 보내주시면 더 나은 서비스 개발에 활용됩니다. 
       """
    }
    
    // openURL
    func send(openURL: OpenURLAction) {
        let urlString = "mailto:\(toAddress)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"
        guard let url = URL(string: urlString) else { return }
        openURL(url) { accepted in
            if !accepted {
                print("ERROR: 현재 기기는 이메일을 지원하지 않습니다.")
            }
        }
    }
}
