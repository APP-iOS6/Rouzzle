//
//  RoutineCompleteView.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/7/24.
//

import SwiftUI

struct RoutineCompleteView: View {
    @Environment(\.dismiss) private var dismiss
    var routineItem: RoutineItem
    var tasks: [TaskList] {
        routineItem.taskList
    }
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(routineItem.emoji)")
                    .font(.bold30)
                
                Text("\(routineItem.title)")
                    .font(.bold24)
            }
            .padding(.top, 60)
            
            Text("1:46 PM ~ 2:06 PM")
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
            }
            .padding(.top, 51)
            
            RouzzleButton(buttonType: .complete) {
                dismiss()
            }
            .padding(.bottom)
        }
        .padding(.horizontal, 46)
    }
}

#Preview {
    RoutineCompleteView(routineItem: RoutineItem.sampleData[0])
}
