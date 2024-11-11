//
//  PassView.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/11/24.
//

import SwiftUI

struct PassView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                colors: [.white, Color.fromRGB(r: 252, g: 255, b: 240)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.bold30)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 10)
                
                Text("당신의 일상에 작은 변화,\n루즐 패스로 시작하세요!")
                    .font(.bold18)
                    .lineSpacing(4)
                    .padding(.vertical, 40)
                
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("월간 루즐 패스 구독")
                            .font(.semibold16)
                        
                        Text("매월 결제")
                            .font(.regular14)
                    }
                    
                    Spacer()
                    
                    Text("₩2,500")
                        .font(.bold16)
                        .foregroundStyle(.accent)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white)
                )
                .padding(.horizontal, 2)
                .shadow(color: .black.opacity(0.1), radius: 2)
                
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("연간 루즐 패스 구독")
                            .font(.semibold16)
                        
                        Text("매년 결제")
                            .font(.regular14)
                    }
                    
                    Spacer()
                    
                    Text("₩15,500")
                        .font(.bold16)
                        .foregroundStyle(.accent)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white)
                )
                .padding(.horizontal, 2)
                .shadow(color: .black.opacity(0.1), radius: 2)
                .padding(.top)
                
                Text("구독 혜택")
                    .font(.bold16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 33)
                
                VStack(alignment: .leading) {
                    HStack {
                        Circle()
                            .frame(width: 46)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("어쩌구 혜택")
                                .font(.semibold14)
                            
                            Text("어쩌구 혜택 효과 어쩌구 혜택 효과 어쩌구")
                                .font(.regular14)
                        }
                    }
                    
                    Divider()
                        .padding(.vertical, 5)
                    
                    HStack {
                        Circle()
                            .frame(width: 46)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("어쩌구 혜택")
                                .font(.semibold14)
                            
                            Text("어쩌구 혜택 효과 어쩌구 혜택 효과 어쩌구")
                                .font(.regular14)
                        }
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(.white))
                .shadow(color: .black.opacity(0.1), radius: 2)
                .padding(.horizontal, 2)
            }
            .padding(.horizontal)
            
            VStack {
                Spacer()
                
                VStack(spacing: 18) {
                    Text("언제든지 걱정없이 취소할 수 있어요.")
                        .font(.regular14)
                        .foregroundStyle(.accent)
                        .padding(.top)
                    
                    Button {
                        
                    } label: {
                        Text("월 구독으로 시작하기")
                            .frame(maxWidth: .infinity, minHeight: 45)
                            .font(.bold20)
                        
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 18)
                    .buttonStyle(.borderedProminent)
                }
                .background(
                    Rectangle()
                        .fill(.white)
                        .ignoresSafeArea(edges: .bottom)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: -2)
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        PassView()
    }
}
