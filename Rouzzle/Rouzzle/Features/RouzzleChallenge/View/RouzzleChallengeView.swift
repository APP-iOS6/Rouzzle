//
//  RouzzleChallengeView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/12/24.
//

import SwiftUI
import RiveRuntime

struct RouzzleChallengeView: View {
    @Environment(RoutineStore.self) private var routineStore
    @State private var selectedPuzzleType: PuzzleType?
    @State private var showPuzzle: Bool = false
    @State private var isShowingGuide: Bool = false
    @State private var showFirstPlayToast: Bool = false
    @State private var toast: ToastModel?
    @State private var achievementTimer: Timer?
    let riveViewModel = RiveViewModel(fileName: "AchievementStart")
    
    private let hasShownFirstPlayToastKey = "hasShownFirstPlayToastKey"
    
    private var gridItemSize: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let horizontalPadding: CGFloat = 16
        let middleSpacing: CGFloat = 32
        return (screenWidth - horizontalPadding - middleSpacing) / 2
    }
    
    private func handlePlayButton(puzzleType: PuzzleType) {
        selectedPuzzleType = puzzleType
        
        // 진행 중인 타이머가 있다면 취소
        achievementTimer?.invalidate()
        achievementTimer = nil
        
        if !UserDefaults.standard.bool(forKey: hasShownFirstPlayToastKey) {
            showFirstPlayToast = true
            UserDefaults.standard.set(true, forKey: hasShownFirstPlayToastKey)
            
            // 타이머 생성 및 저장
            achievementTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
                showPuzzle = true
                achievementTimer = nil // 타이머 참조 제거
            }
        } else {
            showPuzzle = true
        }
    }
    
    var body: some View {
        ZStack {
            // 메인 콘텐츠
            LinearGradient(
                colors: [.white, Color.fromRGB(r: 252, g: 255, b: 240)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 15) {
                    HStack(spacing: 5) {
                        Image(systemName: "info.circle")
                            .font(.light12)
                            .foregroundStyle(.gray)
                        
                        Text("참여 안내")
                            .font(.regular12)
                            .underline()
                            .foregroundStyle(.gray)
                    }
                    .padding(.top, 30)
                    .onTapGesture {
                        isShowingGuide = true
                    }
                    
                    // 메인 챌린지
                    Button {
                        handlePlayButton(puzzleType: .tuna)
                    } label: {
                        ZStack(alignment: .bottomTrailing) {
                            Image(.tuna)
                                .resizable()
                                .frame(maxWidth: .infinity)
                                .aspectRatio(370/278, contentMode: .fit)
                            
                            RouzzleChallengePlayButton(style: .large)
                                .padding([.bottom, .trailing], 16)
                        }
                    }
                    .padding(.top, 0)
                    
                    // 퍼즐 이미지 목록
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ],
                        spacing: 24
                    ) {
                        let puzzleImages = [
                            ("ned", 1.0, PuzzleType.ned),
                            ("chan", 1.0, PuzzleType.chan),
                            ("siyeon", 0.3, nil),
                            ("dongbao", 0.3, nil),
                            ("baengho", 0.3, nil),
                            ("yoshi", 0.3, nil),
                            ("gadi", 0.3, nil),
                            ("maple", 0.3, nil)
                        ]
                        
                        ForEach(puzzleImages, id: \.0) { (imageName, opacity, puzzleType) in
                            if let puzzleType = puzzleType {
                                Button {
                                    handlePlayButton(puzzleType: puzzleType)
                                } label: {
                                    ZStack(alignment: .bottomTrailing) {
                                        Image(imageName)
                                            .resizable()
                                            .aspectRatio(1, contentMode: .fit)
                                            .frame(width: gridItemSize, height: gridItemSize)
                                            .opacity(opacity)
                                            .drawingGroup() // 이미지 렌더링 최적화
                                        
                                        RouzzleChallengePlayButton(style: .small)
                                            .padding([.bottom, .trailing], 8)
                                    }
                                }
                            } else {
                                Button {
                                    toast = ToastModel(
                                        type: .info,
                                        message: "이전 챌린지를 완료해야 진행 가능합니다."
                                    )
                                } label: {
                                    ZStack(alignment: .bottomTrailing) {
                                        Image(imageName)
                                            .resizable()
                                            .aspectRatio(1, contentMode: .fit)
                                            .frame(width: gridItemSize, height: gridItemSize)
                                            .opacity(opacity)
                                            .drawingGroup() // 이미지 렌더링 최적화
                                        
                                        PuzzleLockButton()
                                            .padding([.bottom, .trailing], 8)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                    
                    Text("새로운 퍼즐이 곧 업데이트될 예정입니다.\n많이 기대해 주세요! 😆")
                        .font(.regular16)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 200)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationDestination(isPresented: $showPuzzle) {
                if let puzzleType = selectedPuzzleType {
                    let game = PuzzleGame(puzzleType: puzzleType)
                    RouzzleChallengePuzzleView(puzzleGame: game)
                }
            }
            .customNavigationBar(title: "루즐 챌린지")
            
            VStack {
                HStack {
                    Spacer()
                    PieceCounter(
                        count: routineStore.myPuzzle,
                        phase: routineStore.puzzlePhase
                    ) {
                        routineStore.fetchMyData()
                    }
                        .padding(.top, -35)
                        .padding(.trailing, 16)
                        .background(Color.clear)
                        .zIndex(1)
                }
                Spacer()
            }
            
            if isShowingGuide {
                PuzzleGuideOverlay(isShowingGuide: $isShowingGuide)
                    .ignoresSafeArea()
                    .zIndex(1)
            }
            
            // Achievement 토스트 뷰
            AchievementView(
                message: "＂시작이 반이다!＂",
                riveViewModel: riveViewModel,
                isShowing: $showFirstPlayToast
            )
            .animation(.easeInOut, value: showFirstPlayToast)
        }
        .toastView(toast: $toast)
        .hideTabBar(true)
        .onDisappear {
            // 화면을 벗어날 때 타이머와 토스트를 모두 정리
            achievementTimer?.invalidate()
            achievementTimer = nil
            showFirstPlayToast = false
        }
        .onChange(of: showPuzzle) { _, newValue in
            if newValue {
                // 퍼즐 뷰로 이동할 때 타이머와 토스트를 정리
                achievementTimer?.invalidate()
                achievementTimer = nil
                showFirstPlayToast = false
            }
        }
    }
}
