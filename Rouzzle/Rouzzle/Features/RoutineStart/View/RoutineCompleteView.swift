//
//  RoutineCompleteView.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/7/24.
//

import SwiftUI

struct RoutineCompleteView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("☀️")
                    .font(.bold30)
                
                Text("아침 루틴")
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
                    ForEach(DummyTask.tasks) { task in
                        HStack(spacing: 20) {
                            Text(task.emoji)
                                .font(.bold30)
                            
                            Text(task.title)
                                .font(.semibold16)
                                .strikethrough(task.taskStatus == .completed)
                            
                            Spacer()
                            
                            Text(task.timer == nil ? "없음" :
                                (task.timer! < 60 ? "\(task.timer!)초" : "\(task.timer! / 60)분"))
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
    RoutineCompleteView()
}
