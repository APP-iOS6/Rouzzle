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

    var loadState: LoadState = .none
    var errorMessage: String?
    
    var userInfo = RoutineUser(name: "",
                               profileUrlString: "https://firebasestorage.googleapis.com/v0/b/rouzzle-e4c69.firebasestorage.app/o/UserProfile%2FProfile.png?alt=media&token=94dc34d2-e7dd-4518-bd23-9c7866cfda2e",
                               introduction: "")
    
    /// 유저 데이터와 이미지를 모두 업데이트하는 함수
    @MainActor
    func updateUserProfile(name: String, introduction: String, image: UIImage?) async {
        loadState = .loading
        let userUid = Auth.auth().currentUser?.uid ?? Utils.getDeviceUUID()
        
        var profileUrlString = userInfo.profileUrlString
        
        // 이미지 업로드가 필요한 경우
        if let image = image {
            switch await userService.uploadProfileImage(image, userUid: userUid) {
            case .success(let url):
                profileUrlString = url
            case .failure(let error):
                loadState = .none
                errorMessage = "Error uploading profile image: \(error)"
                print("⛔️ Error uploading profile image: \(error)")
                return
            }
        }
        
        // Firestore에 유저 데이터 업데이트
        let user = RoutineUser(name: name, profileUrlString: profileUrlString, introduction: introduction)
        let result = await userService.uploadUserData(userUid, user: user)
        switch result {
        case .success:
            userInfo = user
            loadState = .completed
            print("✅ User data updated successfully")
        case .failure(let error):
            loadState = .none
            errorMessage = "Error updating user data: \(error)"
            print("⛔️ Error updating user data: \(error)")
        }
    }
}
