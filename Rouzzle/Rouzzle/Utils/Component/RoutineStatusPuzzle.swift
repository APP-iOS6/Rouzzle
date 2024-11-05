//
//  RoutinePuzzle.swift
//  Rouzzle
//
//  Created by 김정원 on 11/3/24.
//

import SwiftUI

enum RoutineStatus {
    case pending
    case completed
    
    var image: Image {
        switch self {
        case .pending:
            Image(.pendingRoutine)
        case .completed:
            Image(.completedRoutine)
        }
    }
}

struct RoutineStatusPuzzle: View {
    
    var status: RoutineStatus
    var emojiText: String = "💪🏻"
    var routineTitle: String = "운동 루틴"
    var inProgressStr: String = "3/5"
    var repeatDay: String = "월  수  금"
    var bellImage: Image = Image(systemName: "bell")
    var routineStartTime: String = "06:30 AM"
    @State var isAlram = false
    
    var body: some View {
        VStack {
            ZStack {
                status.image
                    .resizable()
                    .frame(width: 370, height: 137) // fix 추후 수정예정
                HStack {
                    Text("\(emojiText)")
                        .font(.bold40)
                        .padding(.horizontal, 10)
                    VStack(alignment: .leading, spacing: 5) {
                        Text(routineTitle)
                            .font(.semibold20)
                            .bold()
                        
                        Text(inProgressStr)
                            .font(.regular14)
                            .foregroundStyle(Color.subHeadlineFontColor)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        HStack {
                            Image(systemName: isAlram ? "bell" : "bell.slash")
                            Text(routineStartTime)
                        }
                        .font(.regular16)
                        Text(repeatDay)
                            .font(.regular14)
                    }
                    .foregroundStyle(Color.subHeadlineFontColor)
                    
                }
                .padding(.horizontal, 20)
                .offset(y: -5)
            }
            .opacity(status == .pending ? 1 : 0.6)
        }
    }
}

#Preview {
    RoutineStatusPuzzle(status: .pending)
}
