//
//  EmojiSearchKeywords.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/8/24.
//

import Foundation
// 여기서 키워드 추가
struct EmojiSearchKeywords {
    static let emojiSearchData: [String: [String]] = [
        // 표정/감정
        "😊": ["웃음", "미소", "행복", "기쁨", "스마일", "happy", "smile", "joy", "pleased"],
        "😂": ["웃음", "재미", "즐거움", "웃긴", "laugh", "joy", "funny", "lol", "tears of joy"],
        "😍": ["사랑", "하트", "눈하트", "좋아해", "heart eyes", "love", "adore", "hearts"],
        "😭": ["울음", "눈물", "슬픔", "우는", "crying", "sad", "tear", "sob"],
        "🥺": ["부끄러움", "귀여움", "애교", "pleading", "cute", "shy", "adorable"],
        "😡": ["화남", "분노", "짜증", "angry", "mad", "rage", "upset"],
        
        // 동작/제스처
        "👍": ["좋아요", "긍정", "확인", "좋음", "like", "good", "okay", "approve"],
        "🙏": ["감사", "부탁", "기도", "please", "thank you", "pray", "request"],
        "👋": ["안녕", "인사", "헬로", "바이", "hello", "hi", "wave", "bye"],
        
        // 자연/날씨
        "🌞": ["해", "태양", "날씨", "맑음", "sun", "sunny", "weather", "bright"],
        "🌙": ["달", "밤", "저녁", "moon", "night", "evening", "dark"],
        "⭐": ["별", "반짝", "밤하늘", "star", "sparkle", "shine"],
        
        // 음식
        "☕": ["커피", "카페", "음료", "coffee", "cafe", "drink", "hot"],
        "🍜": ["라면", "국수", "면", "noodles", "ramen", "soup", "hot"],
        "🍕": ["피자", "음식", "배달", "pizza", "food", "delivery"],
        
        // 활동
        "💻": ["컴퓨터", "노트북", "작업", "일", "computer", "laptop", "work"],
        "📱": ["폰", "전화", "휴대폰", "phone", "mobile", "call"],
        "🎮": ["게임", "플레이", "놀이", "game", "play", "gaming"],
        
        // 운동
        "🏃": ["달리기", "운동", "조깅", "run", "exercise", "jogging"],
        "💪": ["운동", "근력", "힘", "exercise", "muscle", "strength"],
        
        // 휴식/취미
        "😴": ["잠", "수면", "피곤", "sleep", "tired", "rest", "nap"],
        "🎵": ["음악", "노래", "music", "song", "melody"],
        "📚": ["책", "독서", "공부", "book", "study", "read"],
        
        // 일상
        "⏰": ["시계", "알람", "기상", "clock", "alarm", "wake up", "time"],
        "🏠": ["집", "홈", "주거", "home", "house", "living"],
        "🛁": ["목욕", "샤워", "bath", "shower", "clean"]
    ]
    // 카테고리별 검색 키워드
    static let categoryKeywords: [EmojiCategory: [String]] = [
        .morning: ["아침", "기상", "아침식사", "morning", "breakfast", "wake up"],
        .afternoon: ["오후", "점심", "업무", "afternoon", "lunch", "work"],
        .evening: ["저녁", "밤", "휴식", "evening", "night", "rest"],
        .health: ["건강", "병원", "운동", "영양", "health", "hospital", "nutrition"],
        .work: ["업무", "회사", "직장", "work", "office", "business"],
        .transport: ["교통", "이동", "차량", "transport", "travel", "vehicle"]
    ]
}
