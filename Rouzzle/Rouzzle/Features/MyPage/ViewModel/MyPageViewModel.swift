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
@MainActor
final class MyPageViewModel {
    
    @ObservationIgnored
    @Injected(\.userService) private var userService
    
    private var userInfo = RoutineUser(name: "",
                               profileUrlString: nil,
                               introduction: "")
    
    var name: String {
        get { userInfo.name }
        set { userInfo.name = newValue }
    }
    
    var introduction: String {
        get { userInfo.introduction }
        set { userInfo.introduction = newValue }
    }
    
    var profileUrl: String? {
        userInfo.profileUrlString
    }
    
    var maxTotalRoutine: Int? {
        userInfo.totalRoutineDay
    }
    
    var currentStreak: Int? {
        userInfo.currentStreak
    }
    
    var loadState: LoadState = .none
    
    // 앱 버전과 빌드 번호
    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
        return "\(version) (\(build))"
    }

    init() {
        loadUserData()
    }
        
    // Firebase에서 유저 데이터를 가져오는 함수
    func loadUserData() {
        Task {
            loadState = .loading
            let userUid = Auth.auth().currentUser?.uid ?? Utils.getDeviceUUID()
            let result = await userService.fetchUserData(userUid)
            
            switch result {
            case .success(let user):
                self.userInfo = user
                
                loadState = .completed
                print("♻️ 데이터 로드")
            case .failure(let error):
                loadState = .none
                print("⛔️ Error fetching user data: \(error)")
            }
        }
    }
}
