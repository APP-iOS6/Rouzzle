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
    
    /// 값도 변환하는 함수
      func mapValues<NewValue>(_ transform: (Value) -> NewValue) -> [Key: NewValue] {
          var newDict: [Key: NewValue] = [:]
          for (key, value) in self {
              newDict[key] = transform(value)
          }
          return newDict
      }
}

extension Dictionary where Key == Int, Value == String {
    /// [Int: String] 딕셔너리를 [Day: Date] 딕셔너리로 변환
    func toDayDateDictionary() -> [Day: Date] {
        var newDict: [Day: Date] = [:]
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        
        for (key, value) in self {
            if let day = Day(rawValue: key), let date = value.toDate() {
                newDict[day] = date
            } else {
                print("Invalid key or date format for key: \(key), value: \(value)")
            }
        }
        return newDict
    }
}
