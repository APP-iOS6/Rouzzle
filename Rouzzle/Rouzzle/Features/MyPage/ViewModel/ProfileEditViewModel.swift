//
//  ProfileEditViewModel.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/13/24.
//

import SwiftUI
import Observation
import Factory
import FirebaseAuth

@Observable
class ProfileEditViewModel {
    
    @ObservationIgnored
    @Injected(\.userService) private var userService
    
    var userInfo = RoutineUser(name: "", profileUrlString: "", introduction: "")
    
    var name: String {
        get { userInfo.name }
        set { userInfo.name = newValue }
    }
    
    var introduction: String {
        get { userInfo.introduction }
        set { userInfo.introduction = newValue }
    }
    
    var profileUrlString: String {
        get { userInfo.profileUrlString }
        set { userInfo.profileUrlString = newValue }
    }
    
    var profileImage: UIImage?
    
    /// 유저 데이터와 이미지를 모두 업데이트하는 함수
    func updateUserProfile(image: UIImage?) async {
        let userUid = Auth.auth().currentUser?.uid ?? Utils.getDeviceUUID()
        
        // 이미지 업로드가 필요한 경우
        if let image = image {
            switch await userService.uploadProfileImage(image, userUid: userUid) {
            case .success(let url):
                userInfo.profileUrlString = url
                profileImage = image
            case .failure(let error):
                print("⛔️ Error uploading profile image: \(error)")
                return
            }
        }
        
        // Firestore에 유저 데이터 업데이트
        let result = await userService.uploadUserData(userUid, user: userInfo)
        switch result {
        case .success:
            print("✅ User data updated successfully")
        case .failure(let error):
            print("⛔️ Error updating user data: \(error)")
        }
    }
    
    /// Firebase에서 유저 데이터와 프로필 이미지를 불러오는 함수
    func loadUserProfileData() async {
        let userUid = Auth.auth().currentUser?.uid ?? Utils.getDeviceUUID()
        
        // Firestore에서 유저 데이터 로드
        switch await userService.fetchUserData(userUid) {
        case .success(let user):
            userInfo = user
            print("♻️ 데이터 로드 완료")
            print("🔗 Profile URL: \(profileUrlString)")
            
            // 프로필 이미지가 있는 경우만 로드
            if !user.profileUrlString.isEmpty {
                switch await userService.loadProfileImage(from: user.profileUrlString) {
                case .success(let image):
                    profileImage = image
                case .failure(let error):
                    print("⛔️ Failed to load profile image: \(error)")
                }
            }
            
        case .failure(let error):
            print("⛔️ Error fetching user data: \(error)")
        }
    }
}
