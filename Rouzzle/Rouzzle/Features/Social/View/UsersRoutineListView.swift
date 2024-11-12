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
        viewModel.routinesByUser.keys.sorted()
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sortedUserIDs, id: \.self) { userid in
                    if let routines = viewModel.routinesByUser[userid] {
                        UserSection(userid: userid, routines: routines)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle()) // 원하는 ListStyle 적용
            .navigationTitle("User Routines")
        }
        .onAppear {
            Task {
                await viewModel.fetchRoutines()
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
    var userid: String
    var routines: [Routine]
    
    var body: some View {
        Section(header: Text("User ID: \(userid)")) {
            ForEach(routines, id: \.self) { routine in
                RoutineRow(routine: routine)
            }
        }
    }
}

#Preview {
    UsersRoutineListView()
}
