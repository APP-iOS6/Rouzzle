//
//  MyPageViewModel.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/13/24.
//

import SwiftUI
import Observation
import FirebaseAuth
import FirebaseStorage
import Factory

@Observable
final class MyPageViewModel {
    
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
        
    // Firebase에서 유저 데이터를 가져오는 함수
    func loadUserData() {
        Task {
            let userUid = Auth.auth().currentUser?.uid ?? Utils.getDeviceUUID()
            let result = await userService.fetchUserData(userUid)
            
            switch result {
            case .success(let user):
                self.userInfo = user
                await loadProfileImage(from: user.profileUrlString) // 프로필 이미지 다운로드
                print("♻️ 데이터 로드")
                print("🔗 Profile URL: \(profileUrlString)") 
            case .failure(let error):
                print("⛔️ Error fetching user data: \(error)")
            }
        }
    }
    
    // Firebase Storage에서 프로필 이미지 로드
    private func loadProfileImage(from urlString: String) async {
        let result = await userService.loadProfileImage(from: urlString)
        
        switch result {
        case .success(let image):
            self.profileImage = image
        case .failure(let error):
            print("⛔️ Failed to load profile image: \(error)")
        }
    }
}
