//
//  MyPageView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import SwiftUI

struct MyPageView: View {
    @State private var viewModel = MyPageViewModel()
    private let subLightGray = Color.fromRGB(r: 237, g: 237, b: 237) // EDEDED
    @State private var isShowingLogoutAlert: Bool = false
    @State private var isShowingPassView: Bool = false
    @State private var tempProfileImage: UIImage? // 변경된 이미지 임시 저장
    @State private var isImageChanged: Bool = false // 이미지 변경 여부 추적
    @State private var showTermsOfService = false
    @State private var showPrivacyPolicy = false
    
    var body: some View {
        NavigationStack {
            Color.white
                .frame(height: 0.1)
            
            ScrollView {
                VStack(alignment: .leading) {
                    Text("마이페이지")
                        .font(.semibold18)
                        .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
                        .padding(.bottom, 10)
                    
                    // MARK: 프사, 닉, 편집 버튼, 자기소개 부분
                    HStack(alignment: .top) {
                        ZStack {
                            if let tempProfileImage = tempProfileImage {
                                // PhotosPicker로 변경된 이미지가 있으면 ProfileImageView 사용
                                ProfileImageView(frameSize: 53, profileImage: tempProfileImage)
                                    .padding(.trailing, 12)
                                    .padding(.top, -2)
                            } else {
                                // 변경된 이미지가 없으면 ProfileCachedImage 사용
                                ProfileCachedImage(frameSize: 53, imageUrl: viewModel.profileUrl)
                                    .padding(.trailing, 12)
                                    .padding(.top, -2)
                            }

                            if viewModel.loadState == .loading {
                                ProgressView()
                                    .padding(.trailing, 12)
                                    .padding(.top, -2)
                                    .tint(.black)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .bottom) {
                                Text(viewModel.name)
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
                            ProfileEditView(name: viewModel.name,
                                            introduction: viewModel.introduction,
                                            profileUrlString: viewModel.profileUrl,
                                            profileImage: tempProfileImage) { updatedImage in
                                tempProfileImage = updatedImage
                                isImageChanged = true
                                viewModel.loadUserData()
                            }
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
                    
                    Text(viewModel.introduction)
                        .font(.regular14)
                        .padding(.vertical)
                    
                    // MARK: PASS, SHOP, 배지 부분
                    ZStack(alignment: .top) {
                        Color.backgroundLightGray
                            .padding(.horizontal, -16)
                        
                        VStack(alignment: .leading) {
                            HStack(spacing: 70) {
                                Button {
                                    isShowingPassView.toggle()
                                } label: {
                                    VStack {
                                        Image(.pass)
                                            .frame(width: 48, height: 48)
                                        
                                        Text("PASS")
                                            .font(.regular14)
                                            .foregroundStyle(.black)
                                    }
                                }
                                
                                Divider()
                                    .padding(.vertical)
                                
                                NavigationLink {
                                    ShopView()
                                } label: {
                                    VStack {
                                        Image(.shop)
                                            .frame(width: 48, height: 48)
                                        
                                        Text("SHOP")
                                            .font(.regular14)
                                            .foregroundStyle(.black)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, minHeight: 104)
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
                            .frame(maxWidth: .infinity, minHeight: 104)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.white)
                            )
                            .padding(.bottom, 20)
                        }
                    }
                    
                    // MARK: 리스트 부분
                    NavigationLink {
                        AccountManagementView()
                    } label: {
                        HStack {
                            Text("계정 관리")
                                .font(.semibold16)
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                        .frame(minHeight: 45)
                    }
                    
                    NavigationLink {
                        FAQView()
                    } label: {
                        HStack {
                            Text("FAQ")
                                .font(.semibold16)
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                        .frame(minHeight: 45)
                    }
                    
                    Button {
                        showTermsOfService.toggle()
                    } label: {
                        HStack {
                            Text("이용 약관")
                                .font(.semibold16)
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                        .frame(minHeight: 45)
                    }
                    
                    Button {
                        showPrivacyPolicy.toggle()
                    } label: {
                        HStack {
                            Text("개인정보 처리방침")
                                .font(.semibold16)
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                        .frame(minHeight: 45)
                    }
                    
                    HStack {
                        Text("버전 정보")
                            .font(.semibold16)
                        
                        Spacer()
                        
                        Text(viewModel.appVersion)
                            .font(.regular16)
                    }
                    .frame(minHeight: 45)
                    
                    NavigationLink {
                        DevInfoView()
                    } label: {
                        HStack {
                            Text("개발자 정보")
                                .font(.semibold16)
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                    }
                    .frame(minHeight: 45)
                    .padding(.bottom) // 탭바와 너무 붙어서 버튼 잘못 눌리는 거 방지용
                }
                .padding(.horizontal)
            }
            .fullScreenCover(isPresented: $isShowingPassView) {
                PassView()
            }
            .onAppear {
                if !isImageChanged {
                    tempProfileImage = nil
                }
                isImageChanged = false
            }
            .sheet(isPresented: $showTermsOfService) {
                SafariView(url: URL(string: "https://overjoyed-garden-c10.notion.site/ae2c4d8c27044967ae9772294f58c428?pvs=74")!)
            }
            .sheet(isPresented: $showPrivacyPolicy) {
                SafariView(url: URL(string: "https://overjoyed-garden-c10.notion.site/1358843116e6463c805fda45dac76ce0?pvs=4")!)
            }
        }
    }
}

#Preview {
    NavigationStack {
        MyPageView()
    }
}
