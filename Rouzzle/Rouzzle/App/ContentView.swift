//
//  ContentView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var tabBarState = TabBarState()
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            RoutineListView(viewModel: .init(context: modelContext))
                .tabItem {
                    Text("홈")
                    Image(systemName: "house.fill")
                }
            
            StatisticView()
                .tabItem {
                    Text("통계")
                    Image(systemName: "list.bullet.clipboard.fill")
                }
            
            RecommendView()
                .tabItem {
                    Text("추천")
                    Image(systemName: "star.fill")
                }
            
            SocialView()
                .tabItem {
                    Text("소셜")
                    Image(systemName: "person.3.fill")
                }
            
            MyPageView()
                .tabItem {
                    Text("마이페이지")
                    Image(systemName: "person.circle.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
