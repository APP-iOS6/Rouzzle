//
//  RoutineCategoryByTime.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/7/24.
//

import Foundation
// 추천 카테고리 데이터 모델
struct RecommendTaskItem {
    let emoji: String
    let title: String
    let timeInterval: Int
    let description: String
    
    func toRecommendTodoTask() -> RecommendTodoTask {
        return RecommendTodoTask(emoji: emoji, title: title, timer: timeInterval)
    }
}

enum RoutineCategoryByTime: String, CaseIterable, Identifiable {
    case morning = "아침"
    case afternoon = "오후"
    case evening = "저녁"
    case rest = "휴식"
    
    var id: String {
        self.rawValue
    }
    
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
    
    var tasks: [RecommendTaskItem] {
        switch self {
        case .morning:
            return [
                RecommendTaskItem(
                    emoji: "🛌",
                    title: "잠자리 정리",
                    timeInterval: 180,
                    description: "매일 아침 잠자리를 정돈한다는 건 그날의 첫 번째 과업을 달성했다는 뜻이에요. 작지만 뭔가 해냈다는 성취감이 자존감으로 이어져요."
                ),
                RecommendTaskItem(
                    emoji: "🧘🏻‍♀️",
                    title: "명상하기",
                    timeInterval: 600,
                    description: "명상은 현재 상황을 직시하고, 사소한 일에 예민하게 반응하지 않도록 돕고, 침착한 태도를 유지하는 데 효과적이에요."
                ),
                RecommendTaskItem(
                    emoji: "🙆🏻",
                    title: "스트레칭",
                    timeInterval: 300,
                    description: "스트레칭으로 몸을 가볍게 풀어보세요. 아침의 나른함과 피로감을 덜어주며, 집중력도 높여줍니다. 목과 어깨, 손목을 풀어주는 스트레칭으로 몸의 긴장도 함께 풀 수 있어요."
                ),
                RecommendTaskItem(
                    emoji: "🍵",
                    title: "차 마시기",
                    timeInterval: 600,
                    description: "아침에 마시는 차는 정신을 맑게 해주는 탁월한 효과가 있어요. 어떤 차든 좋으니, 아침의 여유와 함께 차를 음미해보세요."
                )
            ]
        case .afternoon:
            return [
                RecommendTaskItem(
                    emoji: "🥗",
                    title: "점심 가볍게 먹기",
                    timeInterval: 1800,
                    description: "점심은 소화에 부담을 주지 않는 가벼운 음식으로 섭취하세요. 과한 포만감은 생산성을 저하시키는 주범이에요. 균형 잡힌 식단은 오후 집중력에도 도움을 줍니다."
                ),
                RecommendTaskItem(
                    emoji: "🦵🏻",
                    title: "다리 마사지하기",
                    timeInterval: 300,
                    description: "책상에 오래 앉아 있었다면 다리를 부드럽게 마사지해보세요. 다리의 피로를 풀어주고 혈액순환을 촉진하여, 오후에도 가벼운 몸 상태를 유지할 수 있어요."
                ),
                RecommendTaskItem(
                    emoji: "🚶🏻",
                    title: "가볍게 산책하기",
                    timeInterval: 600,
                    description: "가벼운 산책으로 햇볕을 쬐고 바깥 공기를 마셔보세요. 소화를 돕고, 오후의 나른함을 예방할 수 있어요. 산책하며 기분을 환기하고 활력을 되찾으세요."
                ),
                RecommendTaskItem(
                    emoji: "🧹️️",
                    title: "정리정돈",
                    timeInterval: 300,
                    description: "책상과 주변을 정리하면, 집중력을 회복하고 깔끔한 환경에서 일할 수 있어요. 공간이 정돈되면 마음도 한결 편안해집니다."
                )
            ]
        case .evening:
            return [
                RecommendTaskItem(
                    emoji: "🚿",
                    title: "따뜻한 샤워",
                    timeInterval: 900,
                    description: "따뜻한 물로 샤워하여 하루의 피로를 씻어내고 마음도 함께 정리해보세요. 따뜻한 물은 혈액순환을 돕고 근육을 이완시켜 줍니다. 샤워 후 몸이 가벼워져 깊은 잠을 잘 수 있어요."
                ),
                RecommendTaskItem(
                    emoji: "📚️️",
                    title: "독서하기",
                    timeInterval: 600,
                    description: "저녁에는 좋아하는 책을 짧게라도 읽어보세요. 하루의 긴장과 스트레스를 잊고 마음의 평온을 찾는 시간을 가질 수 있습니다. 독서는 하루의 피로를 달래는 좋은 방법이에요."
                ),
                RecommendTaskItem(
                    emoji: "🎒️️",
                    title: "내일의 간단한 준비",
                    timeInterval: 300,
                    description: "내일 입을 옷이나 필요한 물건을 미리 준비해 아침을 여유롭게 시작하세요. 간단한 준비가 아침을 더 편안하고 쾌적하게 만들어줍니다."
                ),
                RecommendTaskItem(
                    emoji: "📝",
                    title: "감사일기 쓰기",
                    timeInterval: 600,
                    description: "오늘 하루 중 감사했던 순간들을 기록해보세요. 감사를 표현하는 것은 하루를 기분 좋게 마치고 내일을 준비하는 마음가짐에도 좋습니다."
                )
            ]
        case .rest:
            return [
                RecommendTaskItem(
                    emoji: "🛋️",
                    title: "마음껏 쉬기",
                    timeInterval: 1200,
                    description: "소파나 침대에 편안하게 누워 아무 생각 없이 휴식을 취하세요. 단순히 몸과 마음을 쉬게 하는 것은 큰 에너지를 충전하는 데 도움이 됩니다."
                ),
                RecommendTaskItem(
                    emoji: "🎨",
                    title: "간단한 취미 즐기기",
                    timeInterval: 1800,
                    description: "음악 감상이나 그림 그리기 등 좋아하는 취미에 잠깐 빠져보세요. 작은 취미 활동이 스트레스를 줄이고 일상의 소소한 행복을 더해줍니다."
                ),
                RecommendTaskItem(
                    emoji: "📺",
                    title: "차분한 영상 감상",
                    timeInterval: 900,
                    description: "잔잔하고 편안한 영상을 보며 잠시 휴식을 취해보세요. 차분한 영상이 긴장을 풀어주고 편안한 마음 상태를 유지하는 데 도움을 줍니다."
                ),
                RecommendTaskItem(
                    emoji: "🛀️️",
                    title: "온욕 또는 반신욕",
                    timeInterval: 1200,
                    description: "따뜻한 물에 몸을 담가 피로를 푸는 온욕이나 반신욕을 즐겨보세요. 몸의 긴장을 풀고 혈액순환을 촉진하여 깊은 휴식을 돕습니다."
                )
            ]
        }
    }
}
