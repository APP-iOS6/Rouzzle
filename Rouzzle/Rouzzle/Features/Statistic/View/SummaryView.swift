//
//  SummaryView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/13/24.
//

import SwiftUI

struct SummaryView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 최대 연속기록 박스
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("나의 최대 연속 기록이에요!")
                        .font(.medium16)
                    HStack {
                        Text("0일")
                            .font(.bold36)
                        Text("아침 루틴")
                            .font(.regular16)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
                .padding()
                .frame(height: 107)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                )
            }
            
            // 월간 성공률
            Text("월간 성공률")
                .font(.bold16)
            
            // 루틴별 성공률 박스
            VStack(spacing: 10) {
                ForEach(RoutineItem.sampleData, id: \.id) { routine in
                    HStack {
                        Text(routine.emoji)
                            .font(.largeTitle)
                        VStack(alignment: .leading, spacing: 5) {
                            Text(routine.title)
                                .font(.bold16)
                            ProgressBar(progress: .constant(0.62))
                                .frame(height: 10)
                        }
                        Spacer()
                        Text("62%")
                            .font(.bold16)
                    }
                    .padding()
                    .frame(height: 140)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                    )
                }
            }
        }
    }
}

// ProgressBar 컴포넌트
struct ProgressBar: View {
    @Binding var progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray.opacity(0.3))
                HStack(spacing: 2) {
                    Rectangle()
                        .fill(Color.accentColor)
                        .frame(width: geometry.size.width * progress / 2)
                    Rectangle()
                        .fill(Color.themeColor)
                        .frame(width: geometry.size.width * progress / 2)
                }
                .frame(height: geometry.size.height)
            }
        }
    }
}

// 루틴 성공률 컴포넌트
struct RoutineProgressView: View {
    let emoji: String
    let title: String
    let progress: Double
    
    var body: some View {
        HStack {
            Text(emoji)
                .font(.largeTitle)
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.bold16)
                ProgressBar(progress: .constant(progress))
                    .frame(height: 10)
            }
            Spacer()
            Text("\(Int(progress * 100))%")
                .font(.regular16)
        }
        .padding()
        .frame(width: 370, height: 140)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

#Preview {
    SummaryView()
}
