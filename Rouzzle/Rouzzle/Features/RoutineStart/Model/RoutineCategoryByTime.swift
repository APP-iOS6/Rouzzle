//
//  RoutineCategoryByTime.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/7/24.
//

import Foundation

enum RoutineCategoryByTime: String, CaseIterable {
    case morning = "아침"
    case afternoon = "오후"
    case evening = "저녁"
    case rest = "휴식"
    
    var imageName: String {
        return "RecommendTaskTitle_\(self.rawValue)"
    }
    
    var description: String {
        switch self {
        case .morning:
            return "상쾌한 아침 시작하기"
        case .afternoon:
            return "활기찬 오후 만들기"
        case .evening:
            return "하루를 편안히 마무리하기"
        case .rest:
            return "휴식과 재충전 하기"
        }
    }
}
