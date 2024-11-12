//
//  ProfileEditView.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/11/24.
//

import SwiftUI
import PhotosUI

struct ProfileEditView: View {
    @State var nickname: String = ""
    @State var introduction: String = ""
    @State var selectedItem: PhotosPickerItem?
    @State var profileImage: UIImage?
    @State var showPicker: Bool = false
    @Environment(\.dismiss) private var dismiss

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
                TextField("", text: $nickname, prompt: Text("닉네임을 입력해주세요.").font(.regular16))
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color.subHeadlineFontColor)
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
                    // 프로필 변경된 데이터 저장
                    dismiss()
                } label: {
                    Text("완료")
                        .font(.semibold18)  
                }
            }
        }
        // 닉네임 글자 수 9자 제한
        .onChange(of: nickname) {
            if nickname.count > 9 {
                nickname = String(nickname.prefix(9))
            }
        }
        // 자기소개 글자 수 30자 제한
        .onChange(of: introduction) {
            if introduction.count > 30 {
                introduction = String(introduction.prefix(30))
            }
        }
        .photosPicker(isPresented: $showPicker, selection: $selectedItem, matching: .images)
        .onChange(of: selectedItem) {
            Task {
                if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    profileImage = uiImage
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileEditView()
    }
}
