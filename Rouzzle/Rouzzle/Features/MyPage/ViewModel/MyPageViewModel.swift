//
//  MyPageViewModel.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/13/24.
//

import Foundation
import Observation
import FirebaseAuth

@Observable
final class MyPageViewModel {
    private let userService = UserService()
    
    var userName: String  = ""
    var introduction: String  = ""
    
    init() {
        loadUserData()
    }
    
    /// Firebase에서 유저 데이터를 가져오는 함수
    func loadUserData() {
        Task {
            // 예시로 유저 UID가 주어졌다고 가정
            let userUid = Auth.auth().currentUser?.uid ?? Utils.getDeviceUUID()
            let result = await userService.fetchUserData(userUid)
            
            switch result {
            case .success(let user):
                self.userName = user.name
                self.introduction = user.introduction
            case .failure(let error):
                print("Error fetching user data: \(error)")
            }
        }
    }
    
    /// Firebase에 유저 데이터를 업데이트하는 함수
    func updateUserData() {
        Task {
            let userUid = Auth.auth().currentUser?.uid ?? Utils.getDeviceUUID()
            let user = RoutineUser(name: userName, introduction: introduction)
            
            let result = await userService.uploadUserData(userUid, user: user)
            switch result {
            case .success:
                print("User data updated successfully")
            case .failure(let error):
                print("Error updating user data: \(error)")
            }
        }
    }
}
