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

    /// 유저 데이터와 이미지를 모두 업데이트하는 함수
    func updateUserProfile(name: String, introduction: String, image: UIImage?) async {
        let userUid = Auth.auth().currentUser?.uid ?? Utils.getDeviceUUID()
        
        var profileUrlString = ""
        
        // 이미지 업로드가 필요한 경우
        if let image = image {
            switch await userService.uploadProfileImage(image, userUid: userUid) {
            case .success(let url):
                profileUrlString = url
            case .failure(let error):
                print("⛔️ Error uploading profile image: \(error)")
                return
            }
        }
        
        // Firestore에 유저 데이터 업데이트
        let user = RoutineUser(name: name, profileUrlString: profileUrlString, introduction: introduction)
        let result = await userService.uploadUserData(userUid, user: user)
        switch result {
        case .success:
            print("✅ User data updated successfully")
        case .failure(let error):
            print("⛔️ Error updating user data: \(error)")
        }
    }
}
