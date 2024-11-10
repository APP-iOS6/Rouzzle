//
//  Dictionary+Extension.swift
//  Rouzzle
//
//  Created by 김동경 on 11/10/24.
//

import Foundation

extension Dictionary {
    func mapKeys<NewKey>(_ transform: (Key) -> NewKey) -> [NewKey: Value] {
        var newDict: [NewKey: Value] = [:]
        for (key, value) in self {
            newDict[transform(key)] = value
        }
        return newDict
    }
}
