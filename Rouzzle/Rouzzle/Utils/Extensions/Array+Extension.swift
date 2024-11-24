//
//  Array+Extension.swift
//  Rouzzle
//
//  Created by 김정원 on 11/2/24.
//

import Foundation
// out of range 시 crash 를 방지하기 위함
extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
