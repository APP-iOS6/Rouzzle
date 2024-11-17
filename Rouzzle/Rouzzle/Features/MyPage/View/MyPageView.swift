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
    @Environment(AuthStore.self) private var authStore
    @State private var isShowingLogoutAlert: Bool = false
    @State private var isShowingPassView: Bool = false
    @State private var tempProfileImage: UIImage? // 변경된 이미지 임시 저장
    @State private var isImageChanged: Bool = false // 이미지 변경 여부 추적

    var body: some View {
        NavigationStack {
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
                                ProfileCachedImage(imageUrl: viewModel.profileUrl)
                                    .frame(width: 53, height: 53)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.accentColor, lineWidth: 2)
                                    )
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
                        .frame(width: 370, height: 45)
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
                        .frame(width: 370, height: 45)
                    }
                    
                    NavigationLink {
                        Text("이용 약관 노션으로 띄어줄 예정")
                    } label: {
                        HStack {
                            Text("이용 약관")
                                .font(.semibold16)
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                        .frame(width: 370, height: 45)
                    }
                    
                    // 사파리 링크로 노션 띄어줄 예정
                    NavigationLink {
                        Text("개인정보 처리방침 노션으로 띄어줄 예정")
                    } label: {
                        HStack {
                            Text("개인정보 처리방침")
                                .font(.semibold16)
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                        .frame(width: 370, height: 45)
                    }
                    
                    HStack {
                        Text("버전 정보")
                            .font(.semibold16)
                        
                        Spacer()
                        
                        Text(viewModel.appVersion)
                            .font(.regular16)
                    }
                    .frame(width: 370, height: 45)
                    
                    Button {
                        isShowingLogoutAlert.toggle()
                    } label: {
                        HStack {
                            Text("로그아웃")
                                .font(.medium16)
                                .foregroundStyle(.red)
                        }
                        .frame(width: 370, height: 45, alignment: .leading)
                    }
                }
                .padding(.horizontal)
            }
            .customAlert(isPresented: $isShowingLogoutAlert,
                         title: "로그아웃하시겠어요?",
                         message: "",
                         primaryButtonTitle: "로그아웃",
                         primaryAction: { authStore.logOut() })
            .fullScreenCover(isPresented: $isShowingPassView) {
                PassView()
            }
            .onAppear {
                if !isImageChanged {
                    tempProfileImage = nil
                }
                isImageChanged = false
            }
        }
    }
}

#Preview {
    NavigationStack {
        MyPageView()
            .environment(AuthStore())
    }
}
