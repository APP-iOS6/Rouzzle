//
//  ProfileEditView.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/11/24.
//

import SwiftUI

struct ProfileEditView: View {
    @State var nickname: String = ""
    @State var introduction: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                
            } label: {
                ZStack {
                    Image(systemName: "person.fill")
                        .font(.bold50)
                        .foregroundStyle(.accent)
                    
                    Circle()
                        .stroke(.accent, lineWidth: 2)
                        .background(Circle().fill(.black).opacity(0.5))
                        .frame(width: 72, height: 72)
                              
                    Image(systemName: "camera.fill")
                        .foregroundStyle(.white)
                        .font(.bold40)
                }
                .frame(maxWidth: .infinity, alignment: .center)
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
                } label: {
                    Text("완료")
                        .font(.semibold18)  
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
