//
//  PuzzleView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/15/24.
//

import SwiftUI

// swiftlint:disable type_body_length
struct PuzzleView: View {
    let puzzleGame: PuzzleGame
    @State private var pieces: [PuzzlePiece] = []
    let imageSize: CGSize
    let screenSize: CGSize
    
    // 하단 퍼즐 선택 영역의 높이
    private func getDeviceHeightRatio() -> CGFloat {
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        switch (screenWidth, screenHeight) {
        case (440, 821...822): // iPhone 16 Pro Max
            return 0.18
        case (402, 739...740): // iPhone 16 Pro
            return 0.17
        case (430, 800...801): // iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus
            return 0.18
        case (393, 720...721): // iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16
            return 0.17
        case (428, 801): // iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus
            return 0.18
        case (390, 719): // iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14
            return 0.16
        case (375, 684): // iPhone 13 mini, iPhone 12 mini
            return 0.16
        case (414, 770): // iPhone XR, iPhone 11
            return 0.17
        case (414, 774): // iPhone Xs Max, iPhone 11 Pro Max
            return 0.17
        case (375, 690): // iPhone Xs, iPhone 11 Pro, iPhone 12
            return 0.16
        case (375, 603): // iPhone SE
            return 0.18
        default:
            return 0.17
        }
    }
    
    // Y축 위치 계산
    private func calculateYPosition(for piece: PuzzlePiece) -> CGFloat {
        let availableHeight = screenSize.height - getPuzzleAreaHeight()
        let verticalCenter = availableHeight * 0.5
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let deviceAdjustment: CGFloat
        switch (screenWidth, screenHeight) {
        case (440, 821...822): // iPhone 16 Pro Max
            deviceAdjustment = -463
        case (402, 739...740): // iPhone 16 Pro
            deviceAdjustment = -419
        case (430, 800...801): // iPhone 14 Pro Max, iPhone 15 Plus
            deviceAdjustment = -452
        case (393, 720...721): // iPhone 14 Pro, iPhone 15, iPhone 15 Pro
            deviceAdjustment = -409.25
        case (428, 801): // iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus
            deviceAdjustment = -448.7
        case (390, 719): // iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14
            deviceAdjustment = -403.5
        case (375, 684): // iPhone 13 mini, iPhone 12 mini
            deviceAdjustment = -387.5
        case (414, 770): // iPhone XR, iPhone 11
            deviceAdjustment = -431
        case (414, 774): // iPhone Xs Max, iPhone 11 Pro Max
            deviceAdjustment = -431
        case (375, 690): // iPhone Xs, iPhone 11 Pro, iPhone 12
            deviceAdjustment = -386.2
        case (375, 603): // iPhone SE
            deviceAdjustment = -403.5
        default:
            deviceAdjustment = -400
        }
        
        return verticalCenter + piece.correctFrame.midY + deviceAdjustment
    }
    
    // X축 조정값 계산
    private func calculateXAdjustment() -> CGFloat {
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        switch (screenWidth, screenHeight) {
        case (440, 821...822): // iPhone 16 Pro Max
            return -18
        case (402, 739...740): // iPhone 16 Pro
            return -16
        case (430, 800...801): // iPhone 14 Pro Max, iPhone 15 Plus
            return -17.3
        case (393, 720...721): // iPhone 14 Pro, iPhone 15, iPhone 15 Pro
            return -15.6
        case (428, 801): // iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus
            return -17.1
        case (390, 719): // iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14
            return -15.4
        case (375, 684): // iPhone 13 mini, iPhone 12 mini
            return -14.95
        case (414, 770): // iPhone XR, iPhone 11
            return -16.5
        case (414, 774): // iPhone Xs Max, iPhone 11 Pro Max
            return -16.5
        case (375, 690): // iPhone Xs, iPhone 11 Pro, iPhone 12
            return -14.7
        case (375, 603): // iPhone SE
            return -14.7
        default:
            return -15.2
        }
    }
    
    private func getPuzzleAreaHeight() -> CGFloat {
        return screenSize.height * getDeviceHeightRatio()
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ZStack {
                    if let referenceImage = UIImage(named: puzzleGame.puzzleType.imageName) {
                        Image(uiImage: referenceImage)
                            .resizable()
                            .frame(width: imageSize.width, height: imageSize.height)
                            .opacity(0.5)
                            .position(
                                x: screenSize.width / 2,
                                y: (screenSize.height - getPuzzleAreaHeight()) * 0.7 + 1
                            )
                    } else {
                        Text("배경 이미지를 찾을 수 없습니다")
                            .foregroundColor(.red)
                    }
                    
                    ForEach(pieces.filter { $0.isPlaced }) { piece in
                        piece.image
                            .resizable()
                            .frame(
                                width: piece.correctFrame.width,
                                height: piece.correctFrame.height
                            )
                            .position(
                                x: piece.correctFrame.midX + (screenSize.width - imageSize.width) / 2 + calculateXAdjustment(),
                                y: calculateYPosition(for: piece)
                            )
                    }
                    
                    ForEach(pieces.filter { !$0.isPlaced }) { piece in
                        if piece.isSelected {
                            DraggablePuzzlePiece(
                                piece: piece,
                                pieces: $pieces,
                                puzzleGame: puzzleGame,
                                imageSize: imageSize,
                                screenSize: screenSize,
                                calculateYPosition: calculateYPosition,
                                calculateXAdjustment: calculateXAdjustment,
                                onPieceMoved: { updatedPiece in
                                    if let index = pieces.firstIndex(where: { $0.id == updatedPiece.id }) {
                                        pieces[index] = updatedPiece
                                        checkCompletion()
                                    }
                                }
                            )
                        }
                    }
                }
                .frame(height: screenSize.height - getPuzzleAreaHeight())
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(pieces.filter { !$0.isPlaced }) { piece in
                            piece.image
                                .resizable()
                                .frame(
                                    width: piece.correctFrame.width,
                                    height: piece.correctFrame.height
                                )
                                .onTapGesture {
                                    selectPiece(piece)
                                }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
                .frame(height: getPuzzleAreaHeight())
                .background(Color.grayultralight)
            }
            
            if puzzleGame.showNoPiecesAlert {
                MissingPuzzleView(
                    onRoutineButtonTap: {
                        print("루틴 하러 가기")
                        puzzleGame.showNoPiecesAlert = false
                    },
                    onCloseButtonTap: {
                        puzzleGame.showNoPiecesAlert = false
                    }
                )
            }
        }
        .onAppear {
            setupPuzzle()
            printDeviceInfo()
        }
        .alert(isPresented: .constant(puzzleGame.isCompleted)) {
            Alert(
                title: Text("축하합니다"),
                message: Text("퍼즐을 완성했습니다"),
                dismissButton: .default(Text("OK")) {
                    puzzleGame.isCompleted = false
                }
            )
        }
    }
    
    private func selectPiece(_ piece: PuzzlePiece) {
        if piece.isSelected {
            return
        }
        
        _ = pieces.contains(where: { $0.isSelected })
        
        for index in pieces.indices {
            pieces[index].isSelected = false
        }
        
        if let index = pieces.firstIndex(where: { $0.id == piece.id }) {
            pieces[index].isSelected = true
            pieces[index].currentPosition = CGPoint(
                x: screenSize.width / 2,
                y: (screenSize.height - getPuzzleAreaHeight()) / 2
            )
        }
    }
    
    private func setupPuzzle() {
        let puzzleData = loadPuzzleData()
        let scale = imageSize.width / 370
        
        // 저장된 상태 불러오기
        let savedPiecesInfo = puzzleGame.getPlacedPiecesInfo()
        
        // 1. 모든 조각 생성
        let allPieces = puzzleData.enumerated().map { index, data in
            let scaledFrame = CGRect(
                x: data.frame.origin.x * scale,
                y: data.frame.origin.y * scale,
                width: data.frame.width * scale,
                height: data.frame.height * scale
            )
            
            // 현재 인덱스로 조각 이름 생성
            let pieceName = puzzleGame.puzzleType.getPieceImageName(index: index)
            // 저장된 정보에서 현재 조각 찾기
            let savedInfo = savedPiecesInfo.first { $0.pieceName == pieceName }
            
            guard let pieceImage = UIImage(named: pieceName) else {
                print("⚠️ 이미지를 찾을 수 없습니다: \(pieceName)")
                return PuzzlePiece(
                    image: Image(systemName: "questionmark.square"),
                    correctFrame: scaledFrame,
                    currentPosition: .zero,
                    isPlaced: false,
                    isSelected: false,
                    index: index  // 인덱스 추가
                )
            }
            
            if let savedInfo = savedInfo, savedInfo.isPlaced {
                // 저장된 위치에 조각 복원
                return PuzzlePiece(
                    image: Image(uiImage: pieceImage),
                    correctFrame: scaledFrame,
                    currentPosition: savedInfo.position.toCGPoint(),
                    isPlaced: true,
                    isSelected: false,
                    index: index  // 인덱스 추가
                )
            } else {
                // 미배치 조각
                return PuzzlePiece(
                    image: Image(uiImage: pieceImage),
                    correctFrame: scaledFrame,
                    currentPosition: .zero,
                    isPlaced: false,
                    isSelected: false,
                    index: index  // 인덱스 추가
                )
            }
        }
        
        // 2. 배치된 조각과 미배치 조각 분리
        let placedPieces = allPieces.filter { $0.isPlaced }
        let unplacedPieces = allPieces.filter { !$0.isPlaced }.shuffled()
        
        // 3. 미배치 조각들 하단에 배치
        let adjustedUnplacedPieces = unplacedPieces.map { piece in
            var adjustedPiece = piece
            let xOffset = CGFloat(unplacedPieces.firstIndex(where: { $0.id == piece.id }) ?? 0) * (piece.correctFrame.width + 15) + 20
            let yOffset = screenSize.height - getPuzzleAreaHeight()/2
            adjustedPiece.currentPosition = CGPoint(x: xOffset, y: yOffset)
            return adjustedPiece
        }
        
        // 4. 최종 배열 설정
        pieces = placedPieces + adjustedUnplacedPieces
    }

private func loadPuzzleData() -> [(imageName: String, frame: CGRect)] {
    // 프레임 데이터 정의 (위에서 제공한 x, y, width, height 값 사용)
    let frameData: [CGRect] = [
        CGRect(x: 16, y: 404, width: 61, height: 89),
        CGRect(x: 58, y: 404, width: 100, height: 68),
        CGRect(x: 139, y: 404, width: 62, height: 89),
        CGRect(x: 183, y: 404, width: 98, height: 68),
        CGRect(x: 263, y: 404, width: 62, height: 89),
        CGRect(x: 307, y: 404, width: 79, height: 68),
        CGRect(x: 16, y: 472, width: 79, height: 71),
        CGRect(x: 77, y: 452, width: 62, height: 112),
        CGRect(x: 121, y: 472, width: 98, height: 71),
        CGRect(x: 201, y: 452, width: 62, height: 112),
        CGRect(x: 244, y: 472, width: 100, height: 71),
        CGRect(x: 325, y: 452, width: 61, height: 112),
        CGRect(x: 16, y: 522, width: 61, height: 111),
        CGRect(x: 58, y: 543, width: 100, height: 70),
        CGRect(x: 139, y: 522, width: 62, height: 111),
        CGRect(x: 183, y: 543, width: 98, height: 70),
        CGRect(x: 262, y: 522, width: 63, height: 111),
        CGRect(x: 307, y: 543, width: 79, height: 70),
        CGRect(x: 16, y: 613, width: 79, height: 69),
        CGRect(x: 77, y: 592, width: 62, height: 90),
        CGRect(x: 121, y: 613, width: 98, height: 69),
        CGRect(x: 201, y: 592, width: 62, height: 90),
        CGRect(x: 244, y: 613, width: 100, height: 69),
        CGRect(x: 325, y: 592, width: 61, height: 90)
    ]
    
    // 각 프레임에 대해 현재 퍼즐 타입에 맞는 이미지 이름 생성
    return frameData.enumerated().map { (index, frame) in
        (imageName: puzzleGame.puzzleType.getPieceImageName(index: index), frame: frame)
    }
}

private func checkCompletion() {
    if pieces.allSatisfy({ $0.isPlaced }) {
        puzzleGame.isCompleted = true
        // 완성 상태 저장
        puzzleGame.savePuzzleProgress(pieces: pieces)  // 변경된 부분 - pieces 배열 전체를 전달
    }
}
}

extension PuzzleView {
    private func printDeviceInfo() {
        print("""
                    === 디바이스 정보 ===
                    📱 화면 크기
                    가로: \(screenSize.width)
                    세로: \(screenSize.height)
                    
                    📏 하단 영역 정보
                    비율: \(getDeviceHeightRatio())
                    높이: \(getPuzzleAreaHeight())
                    ==================
                    """)
    }
}
// swiftlint:enable type_body_length
