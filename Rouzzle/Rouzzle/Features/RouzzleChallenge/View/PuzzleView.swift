//
//  PuzzleView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/15/24.
//

import SwiftUI

struct PuzzlePiece: Identifiable {
    var id = UUID()
    var image: Image
    var correctFrame: CGRect
    var currentPosition: CGPoint
    var isPlaced: Bool = false
    var isSelected: Bool = false
}

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
            deviceAdjustment = -455
        case (402, 739...740): // iPhone 16 Pro
            deviceAdjustment = -412
        case (430, 800...801): // iPhone 14 Pro Max, iPhone 15 Plus
            deviceAdjustment = -444.3
        case (393, 720...721): // iPhone 14 Pro, iPhone 15, iPhone 15 Pro
            deviceAdjustment = -402.35
        case (428, 801): // iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus
            deviceAdjustment = -441.4
        case (390, 719): // iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14
            deviceAdjustment = -396.7
        case (375, 684): // iPhone 13 mini, iPhone 12 mini
            deviceAdjustment = -381
        case (414, 770): // iPhone XR, iPhone 11
            deviceAdjustment = -424.5
        case (414, 774): // iPhone Xs Max, iPhone 11 Pro Max
            deviceAdjustment = -423.8
        case (375, 690): // iPhone Xs, iPhone 11 Pro, iPhone 12
            deviceAdjustment = -380
        case (375, 603): // iPhone SE
            deviceAdjustment = -397
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
        VStack(spacing: 0) {
            ZStack {
                if let referenceImage = UIImage(named: puzzleGame.puzzleType.imageName) {
                    Image(uiImage: referenceImage)
                        .resizable()
                        .frame(width: imageSize.width, height: imageSize.height)
                        .opacity(0.2)
                        .position(
                            x: screenSize.width / 2,
                            y: (screenSize.height - getPuzzleAreaHeight()) * 0.7 + 1
                        )
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
        .onAppear {
            setupPuzzle()
            printDeviceInfo()
        }
        .alert("퍼즐 부족", isPresented: .constant(puzzleGame.showNoPiecesAlert)) {
            Button("확인") { puzzleGame.showNoPiecesAlert = false }
        } message: {
            Text("사용 가능한 퍼즐이 없습니다.")
        }
        .alert(isPresented: .constant(puzzleGame.isCompleted)) {
            Alert(
                title: Text("Congratulations!"),
                message: Text("Puzzle completed."),
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
        
        let shuffledData = puzzleData.shuffled()
        
        pieces = shuffledData.enumerated().map { index, data in
            let scaledFrame = CGRect(
                x: data.frame.origin.x * scale,
                y: data.frame.origin.y * scale,
                width: data.frame.width * scale,
                height: data.frame.height * scale
            )
            
            let xOffset = CGFloat(index) * (scaledFrame.width + 15) + 20
            let yOffset = screenSize.height - getPuzzleAreaHeight()/2
            
            return PuzzlePiece(
                image: Image(uiImage: UIImage(named: data.imageName) ?? UIImage()),
                correctFrame: scaledFrame,
                currentPosition: CGPoint(x: xOffset, y: yOffset),
                isPlaced: false,
                isSelected: false
            )
        }
    }
    
    private func loadPuzzleData() -> [(imageName: String, frame: CGRect)] {
        return [
            ("tuna01", CGRect(x: 16, y: 397, width: 65, height: 93)),
            ("tuna02", CGRect(x: 56, y: 397, width: 105, height: 73)),
            ("tuna03", CGRect(x: 136, y: 397, width: 68, height: 93)),
            ("tuna04", CGRect(x: 180, y: 397, width: 104, height: 73)),
            ("tuna05", CGRect(x: 260, y: 397, width: 67, height: 93)),
            ("tuna06", CGRect(x: 303, y: 397, width: 83, height: 73)),
            ("tuna07", CGRect(x: 16, y: 464, width: 83, height: 75)),
            ("tuna08", CGRect(x: 75, y: 443, width: 68, height: 117)),
            ("tuna09", CGRect(x: 118, y: 464, width: 105, height: 75)),
            ("tuna10", CGRect(x: 198, y: 443, width: 68, height: 117)),
            ("tuna11", CGRect(x: 241, y: 464, width: 105, height: 75)),
            ("tuna12", CGRect(x: 321, y: 443, width: 65, height: 117)),
            ("tuna13", CGRect(x: 16, y: 512, width: 65, height: 117)),
            ("tuna14", CGRect(x: 56, y: 533, width: 105, height: 76)),
            ("tuna15", CGRect(x: 136, y: 512, width: 68, height: 117)),
            ("tuna16", CGRect(x: 180, y: 533, width: 104, height: 76)),
            ("tuna17", CGRect(x: 260, y: 512, width: 67, height: 117)),
            ("tuna18", CGRect(x: 303, y: 533, width: 83, height: 76)),
            ("tuna19", CGRect(x: 16, y: 603, width: 83, height: 72)),
            ("tuna20", CGRect(x: 75, y: 582, width: 68, height: 93)),
            ("tuna21", CGRect(x: 118, y: 603, width: 105, height: 72)),
            ("tuna22", CGRect(x: 198, y: 582, width: 68, height: 93)),
            ("tuna23", CGRect(x: 241, y: 603, width: 105, height: 72)),
            ("tuna24", CGRect(x: 321, y: 582, width: 65, height: 93))
        ]
    }
    
    private func checkCompletion() {
        if pieces.allSatisfy({ $0.isPlaced }) {
            puzzleGame.isCompleted = true
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
