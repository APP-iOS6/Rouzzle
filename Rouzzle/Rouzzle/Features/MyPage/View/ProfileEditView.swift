//
//  ProfileEditView.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/11/24.
//

import SwiftUI
import PhotosUI

struct ProfileEditView: View {
    @State var name: String
    @State var introduction: String
    @State var profileImage: UIImage?
        
    @State private var viewModel = ProfileEditViewModel()
    @State private var selectedItem: PhotosPickerItem?
    @State private var showPicker: Bool = false
    @State private var isNameEmpty: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                showPicker.toggle()
            } label: {
                if let profileImage = profileImage {
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
                TextField("", text: $name, prompt: Text("닉네임을 입력해주세요.").font(.regular16))
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(isNameEmpty ? .red : Color.subHeadlineFontColor)
                
                Text(isNameEmpty ? "닉네임은 비워둘 수 없습니다." : "")
                    .foregroundStyle(.red)
                    .font(.regular10)
            }
            .padding(.bottom, 30)
            
            Text("자기소개")
                .font(.semibold16)
                .padding(.bottom, 5)
            
            VStack {
                TextField("", text: $introduction, prompt: Text("자기소개를 입력해주세요.").font(.regular16))
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
                    if name.isEmpty {
                        isNameEmpty = true
                    } else {
                        Task {
                            await viewModel.updateUserProfile(
                                name: name,
                                introduction: introduction,
                                image: profileImage
                            )
                            action()
                            dismiss()
                        }
                    }
                } label: {
                    Text("완료")
                        .font(.semibold18)
                }
                .disabled(viewModel.loadState == .loading)
            }
        }
        // 닉네임 글자 수 9자 제한
        .onChange(of: name) {  _, newValue in
            if newValue.count > 9 {
                name = String(newValue.prefix(9))
            }
        }
        // 자기소개 글자 수 30자 제한
        .onChange(of: introduction) {  _, newValue in
            if newValue.count > 30 {
                introduction = String(newValue.prefix(30))
            }
        }
        .photosPicker(isPresented: $showPicker,
                      selection: $selectedItem,
                      matching: .images)
        .onChange(of: selectedItem) {
            Task {
                if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    profileImage = uiImage
                } else {
                    print("⛔️ 지원하지 않는 이미지 형식이거나 파일을 불러오는 데 실패했습니다.")
                }
            }
        }
        .overlay {
            if viewModel.loadState == .loading {
                ProgressView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileEditView(name: "", introduction: "", action: {})
    }
}
