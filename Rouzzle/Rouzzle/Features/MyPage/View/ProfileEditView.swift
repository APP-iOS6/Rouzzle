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
    @State var profileUrlString: String?
    @State var profileImage: UIImage?
    
    @State private var viewModel = ProfileEditViewModel()
    @State private var selectedItem: PhotosPickerItem?
    @State private var showPicker: Bool = false
    @State private var isNameEmpty: Bool = false
    @State private var isCameraOverlayVisible: Bool = true
    @State private var showSheet: Bool = false
    @State private var isImageChanged: Bool = false

    @Environment(\.dismiss) private var dismiss
    let action: (UIImage?) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                showSheet.toggle()
            } label: {
                ZStack {
                    if let profileImage = profileImage, isImageChanged {
                        // PhotosPicker로 선택된 이미지가 있으면 ProfileImageView 사용
                        ProfileImageView(frameSize: 72, profileImage: profileImage)
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        // 선택된 이미지가 없으면 ProfileCachedImage 사용
                        ProfileCachedImage(frameSize: 72, imageUrl: profileUrlString)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    // 처음 진입 시에만 오버레이 보이도록 설정
                    if isCameraOverlayVisible {
                        Circle()
                            .fill(.black).opacity(0.4)
                            .frame(width: 72, height: 72)
                        
                        Image(systemName: "camera")
                            .foregroundStyle(.white)
                            .font(.bold30)
                    }
                }
            }
            .padding(.vertical, 30)
            .sheet(isPresented: $showSheet) {
                ProfileImageSettingSheet(editAction: {
                    showPicker.toggle()
                    isCameraOverlayVisible = false
                }, deleteAction: {
                    profileUrlString = nil
                    profileImage = nil
                    isCameraOverlayVisible = false
                })
                .presentationDetents([.fraction(0.25)])
            }
            
            Text("닉네임")
                .font(.semibold16)
                .padding(.bottom, 5)
            
            VStack(alignment: .leading) {
                TextField("닉네임을 입력해 주세요.", text: $name)
                    .font(.regular16)

                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(isNameEmpty ? .red : Color.subHeadlineFontColor)
                
                Text(isNameEmpty ? "닉네임은 비워둘 수 없습니다." : "")
                    .foregroundStyle(.red)
                    .font(.regular12)
            }
            .padding(.bottom, 30)
            
            Text("자기소개")
                .font(.semibold16)
                .padding(.bottom, 5)
            
            VStack {
                TextField("자기소개를 입력해 주세요.", text: $introduction)
                    .font(.regular16)

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
                            profileUrlString = viewModel.userInfo.profileUrlString
                            action(profileImage)
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
                    isImageChanged = true
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
        ProfileEditView(name: "", introduction: "", action: { _  in })
    }
}
