//
//  UsersRoutineListView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/13/24.
//

import Foundation
import SwiftUI

struct UsersRoutineListView: View {
    @State var viewModel: SocialViewModel = SocialViewModel()
    
    private var sortedUserIDs: [String] {
        viewModel.nicknameToRoutines.keys.sorted()
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sortedUserIDs, id: \.self) { nickname in
                    if let routines = viewModel.nicknameToRoutines[nickname] {
                        UserSection(nickname: nickname, routines: routines)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle()) // 원하는 ListStyle 적용
            .navigationTitle("User Routines")
        }
        .onAppear {
            Task {
                await viewModel.fetchUsersAndRoutines()
            }
        }
    }
}

struct RoutineRow: View {
    var routine: Routine
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(routine.title)
                .font(.headline)
            Text(routine.emoji)
                .font(.title)
        }
        .padding(.vertical, 4)
    }
}

struct UserSection: View {
    var nickname: String
    var routines: [Routine]
    
    var body: some View {
        Section(header: Text("\(nickname)")) {
            ForEach(routines, id: \.self) { routine in
                RoutineRow(routine: routine)
            }
        }
    }
}

#Preview {
    UsersRoutineListView()
}
