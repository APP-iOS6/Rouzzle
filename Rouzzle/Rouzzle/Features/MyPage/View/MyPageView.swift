//
//  MyPageView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import SwiftUI

struct MyPageView: View {
    private let subLightGray = Color.fromRGB(r: 237, g: 237, b: 237) // EDEDED
    private let backgroundLightGray = Color.fromRGB(r: 249, g: 249, b: 249) // F9F9F9
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("마이페이지")
                        .font(.semibold18)
                        .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
                        .padding(.bottom, 10)
                    
                    HStack(alignment: .top) {
                        Image(systemName: "person.fill")
                            .frame(width: 53, height: 53)
                            .font(.bold40)
                            .foregroundStyle(.accent)
                            .background(
                                Circle()
                                    .stroke(.accent, lineWidth: 2)
                            )
                            .padding(.trailing, 12)
                            .padding(.top, -2)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .bottom) {
                                Text("효짱")
                                    .font(.bold18)
                                
                                Text("루즐러")
                                    .foregroundStyle(.accent)
                                    .font(.semibold16)
                            }
                            
                            Text("🧩 루틴 10일차 · 🔥 연속 성공 5일차")
                                .foregroundStyle(Color.subHeadlineFontColor)
                                .font(.medium12)
                        }
                        
                        Spacer()
                        
                        NavigationLink {
                            ProfileEditView()
                        } label: {
                            Text("프로필 편집")
                                .font(.medium14)
                                .foregroundStyle(.black)
                                .frame(width: 88, height: 30)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(subLightGray, lineWidth: 1)
                                )
                        }
                    }
                    
                    Text("나 김효정.. 노원 대표 뱅갈호랑이, 누가 날 막을소냐!")
                        .font(.regular14)
                        .padding(.vertical)
                    
                    // MARK: PASS, SHOP, 배지 부분
                    ZStack(alignment: .top) {
                        backgroundLightGray
                            .padding(.horizontal, -16)
                        
                        VStack(alignment: .leading) {
                            HStack(spacing: 70) {
                                NavigationLink {
                                    // 구독 페이지 이동
                                } label: {
                                    VStack {
                                        Image(.pass)
                                        
                                        Text("PASS")
                                            .font(.regular14)
                                            .foregroundStyle(.black)
                                    }
                                }
                                
                                Divider()
                                    .padding(.vertical)
                                
                                NavigationLink {
                                    // Shop 페이지 이동
                                } label: {
                                    VStack {
                                        Image(.shop)
                                        
                                        Text("SHOP")
                                            .font(.regular14)
                                            .foregroundStyle(.black)
                                    }
                                }
                            }
                            .frame(width: 370, height: 104)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.white)
                            )
                            .padding(.top, 20)
                            
                            Text("달성 배지")
                                .font(.semibold16)
                                .padding(.top, 32)
                            
                            HStack {
                                // 배지들 가로로 정렬 예정
                                Text("루즐 챌린지를 달성해 배지를 모아보세요!")
                                    .foregroundStyle(Color.subHeadlineFontColor)
                                    .font(.regular14)
                            }
                            .frame(width: 370, height: 104)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.white)
                            )
                            .padding(.bottom, 20)
                        }
                    }
                    
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            Text("개인정보")
                                .font(.semibold16)
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                        .frame(width: 370, height: 45)
                    }
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Text("이메일 연동")
                                .font(.semibold16)
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                        .frame(width: 370, height: 45)
                    }
                    
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            Text("Q&A")
                                .font(.semibold16)
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                        .frame(width: 370, height: 45)
                    }
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Text("로그아웃")
                                .font(.medium16)
                                .foregroundStyle(.red)
                        }
                        .frame(width: 370, height: 45, alignment: .leading)
                    }
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Text("계정탈퇴")
                                .font(.medium16)
                                .foregroundStyle(.red)
                        }
                        .frame(width: 370, height: 45, alignment: .leading)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    NavigationStack {
        MyPageView()
    }
}
