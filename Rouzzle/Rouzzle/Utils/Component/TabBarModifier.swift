//
//  TabBarModifier.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/15/24.
//

import SwiftUI

@Observable class TabBarState {
    var isVisible: Bool = true
}

struct TabBarModifier: ViewModifier {
    let isHidden: Bool
    
    func body(content: Content) -> some View {
        content
            .toolbar(isHidden ? .hidden : .visible, for: .tabBar)
    }
}

extension View {
    func hideTabBar(_ isHidden: Bool = true) -> some View {
        self.modifier(TabBarModifier(isHidden: isHidden))
    }
}
