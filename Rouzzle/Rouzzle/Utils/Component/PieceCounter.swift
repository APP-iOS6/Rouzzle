//
//  PieceCounter.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/12/24.
//

import SwiftUI

struct PieceCounter: View {
    let count: Int
    var phase: Phase
    let retry: () -> Void
    
    var body: some View {
        switch phase {
        case .loading:
            loadingPuzzle
        case .failed:
            errorPuzzle
        case .completed:
            counterContent
        }
    }
    
    private var loadingPuzzle: some View {
        HStack {
            Image(.piece)
                .resizable()
                .scaledToFit()
                .frame(height: 18)
            ProgressView()
        }
        .frame(width: 70, height: 30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: .black.opacity(0.1), radius: 2)
        )
    }
    
    private var errorPuzzle: some View {
        HStack {
            Image(.piece)
                .resizable()
                .scaledToFit()
                .frame(height: 18)
            
            Button {
                retry()
            } label: {
                Image(systemName: "arrow.clockwise")
            }
        }
        .frame(width: 70, height: 30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: .black.opacity(0.1), radius: 2)
        )
    }
    
    private var counterContent: some View {
        HStack {
            Image(.piece)
                .resizable()
                .scaledToFit()
                .frame(height: 18)
            
            Text("\(count)")
                .font(.medium16)
                .foregroundStyle(.black)
        }
        .frame(width: 70, height: 30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: .black.opacity(0.1), radius: 2)
        )
    }
}

#Preview {
    PieceCounter(count: 9, phase: .loading) { }
}
