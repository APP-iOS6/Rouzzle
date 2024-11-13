//
//  ProfileEditView.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/11/24.
//

import SwiftUI
import PhotosUI

struct ProfileEditView: View {
    @State private var viewModel = ProfileEditViewModel()
    @State var selectedItem: PhotosPickerItem?
    @State var showPicker: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                showPicker.toggle()
            } label: {
                if let profileImage = viewModel.profileImage {
                    ProfileImageView(frameSize: 72, profileImage: profileImage)
                        .overlay(
                            Circle()
                                .stroke(.accent, lineWidth: 2)
                        )
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ZStack {
                        EmptyProfileView(frameSize: 72)
                        
                        Circle()
                            .fill(.black).opacity(0.4)
                            .frame(width: 72, height: 72)
                        
                        Image(systemName: "camera.fill")
                            .foregroundStyle(.white)
                            .font(.bold30)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
            }
            .padding(.vertical, 30)
            
            Text("닉네임")
                .font(.semibold16)
                .padding(.bottom, 5)
            
            VStack {
                TextField("", text: $viewModel.name, prompt: Text("닉네임을 입력해주세요.").font(.regular16))
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color.subHeadlineFontColor)
            }
            .padding(.bottom, 30)
            
            Text("자기소개")
                .font(.semibold16)
                .padding(.bottom, 5)
            
            VStack {
                TextField("", text: $viewModel.introduction, prompt: Text("자기소개를 입력해주세요.").font(.regular16))
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color.subHeadlineFontColor)
            }
            
            Spacer()
        }
        .customNavigationBar(title: "프로필 수정")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        await viewModel.updateUserProfile(image: viewModel.profileImage)
                        dismiss()
                    }
                } label: {
                    Text("완료")
                        .font(.semibold18)
                }
            }
        }
        // 닉네임 글자 수 9자 제한
        .onChange(of: viewModel.name) {  _, newValue in
            if newValue.count > 9 {
                viewModel.name = String(newValue.prefix(9))
            }
        }
        // 자기소개 글자 수 30자 제한
        .onChange(of: viewModel.introduction) {  _, newValue in
            if newValue.count > 30 {
                viewModel.introduction = String(newValue.prefix(30))
            }
        }
        .photosPicker(isPresented: $showPicker,
                      selection: $selectedItem,
                      matching: .images)
        .onChange(of: selectedItem) {
            Task {
                if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    viewModel.profileImage = uiImage
                } else {
                    print("⛔️ 지원하지 않는 이미지 형식이거나 파일을 불러오는 데 실패했습니다.")
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadUserProfileData()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileEditView()
    }
}
