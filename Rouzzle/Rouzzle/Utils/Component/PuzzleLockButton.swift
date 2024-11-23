//
//  PuzzleLockButton.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/12/24.
//

import SwiftUI

struct PuzzleLockButton: View {
    private let lockImage = Image(systemName: "lock.circle.fill")
    
    var body: some View {
        lockImage
            .resizable()
            .frame(width: 29, height: 29)
            .foregroundStyle(.white, .darkgray)
            .symbolRenderingMode(.palette)
            .drawingGroup()
    }
}
