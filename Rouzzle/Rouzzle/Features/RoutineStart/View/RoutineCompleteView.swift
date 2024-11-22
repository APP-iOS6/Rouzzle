//
//  RoutineCompleteView.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/7/24.
//

import SwiftUI

struct RoutineCompleteView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(RoutineStore.self) private var routineStore
    @Binding var path: NavigationPath // 상위 뷰로부터 바인딩
    var routineTakeTime: (Date?, Date?)
    var tasks: [TaskList] {
        routineStore.routineItem!.taskList
    }
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(routineStore.routineItem!.emoji)")
                    .font(.bold30)
                
                Text("\(routineStore.routineItem!.title)")
                    .font(.bold24)
            }
            .padding(.top, 60)
            
            Text("\(routineTakeTime.0?.toTimeString() ?? "") ~ \(routineTakeTime.1?.toTimeString() ?? "")")
                .font(.regular16)
                .foregroundStyle(Color.subHeadlineFontColor)
                .padding(.top)
            
            HStack {
                VStack(spacing: 6) {
                    Text("연속일")
                        .font(.regular16)
                        .foregroundStyle(Color.subHeadlineFontColor)
                    
                    Text("2")
                        .font(.bold24)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                    .frame(height: 60)
                
                VStack(spacing: 6) {
                    Text("누적일")
                        .font(.regular16)
                        .foregroundStyle(Color.subHeadlineFontColor)
                    
                    Text("4")
                        .font(.bold24)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(height: 113)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.fromRGB(r: 250, g: 250, b: 250))
            )
            .padding(.top, 39)
            .padding(.horizontal, 46)
            
            ScrollView {
                VStack(spacing: 18) {
                    ForEach(tasks) { task in
                        HStack(spacing: 20) {
                            Text("\(task.emoji)")
                                .font(.bold30)
                            
                            Text(task.title)
                                .font(.semibold16)
                                .strikethrough()
                            
                            Spacer()
                            
                            Text(task.timer == 0 ? "없음" :
                                (task.timer < 60 ? "\(task.timer)초" : "\(task.timer / 60)분"))
                                .font(.regular14)
                                .foregroundStyle(Color.subHeadlineFontColor)
                        }
                        
                    }
                }
                .padding(.horizontal, 46)
            }
            .padding(.top, 51)
            
            RouzzleButton(buttonType: .complete) {
                Task {
                    await routineStore.checkTodayPuzzleReward()
                }
                path.removeLast(path.count) // 네비게이션 스택 초기화
            }
            .padding(.bottom)
            .padding()
        }
        
    }
}

#Preview {
    RoutineCompleteView(
        path: .constant(NavigationPath())
    )
}
