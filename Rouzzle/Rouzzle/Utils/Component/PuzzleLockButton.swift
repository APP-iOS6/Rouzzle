//
//  PuzzleLockButton.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/12/24.
//

import SwiftUI

struct PuzzleLockButton: View {
   var body: some View {
       Image(systemName: "lock.circle.fill")
           .resizable()
           .frame(width: 29, height: 29)
           .foregroundStyle(.white, .darkgray)
           .symbolRenderingMode(.palette)
   }
}

#Preview {
   PuzzleLockButton()
}
