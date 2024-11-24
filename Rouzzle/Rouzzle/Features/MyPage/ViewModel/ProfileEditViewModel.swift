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
import FirebaseFirestore
import FirebaseStorage

@Observable
class ProfileEditViewModel {
    
    @ObservationIgnored
    @Injected(\.userService) private var userService

    var loadState: LoadState = .none
    var errorMessage: String?
    
    var userInfo = RoutineUser(name: "",
                               profileUrlString: nil,
                               introduction: "")
    
    /// 유저 데이터와 이미지를 모두 업데이트하는 함수
    @MainActor
    func updateUserProfile(name: String, introduction: String, image: UIImage?) async {
        loadState = .loading
        let userUid = Auth.auth().currentUser?.uid
        
        var profileUrlString = userInfo.profileUrlString
        
        // 이미지 업로드가 필요한 경우
        if let image = image {
            switch await userService.uploadProfileImage(image, userUid: userUid!) {
            case .success(let url):
                profileUrlString = url
            case .failure(let error):
                loadState = .none
                errorMessage = "Error uploading profile image: \(error)"
                print("⛔️ Error uploading profile image: \(error)")
                return
            }
        } else if profileUrlString == nil {
            do {
                try await deleteStorageData(for: userUid!)
            } catch {
                loadState = .none
                errorMessage = "Error deleting profile image: \(error.localizedDescription)"
                print("⛔️ Error deleting profile image: \(error)")
                return
            }
        }
        
        var data: [String: Any] = [
            "name": name,
            "introduction": introduction
        ]
        
        if let profileUrlString = profileUrlString {
            data["profileUrlString"] = profileUrlString
        } else {
            data["profileUrlString"] = FieldValue.delete() // 필드 삭제
        }
        
        // Firestore에 유저 데이터 업데이트
        let db = Firestore.firestore()
        do {
            try await db.collection("User").document(userUid!).updateData(data)
            userInfo.name = name
            userInfo.introduction = introduction
            userInfo.profileUrlString = profileUrlString // nil 또는 업데이트된 값
            loadState = .completed
            print("✅ User data updated successfully")
        } catch {
            loadState = .none
            errorMessage = "Error updating user data: \(error.localizedDescription)"
            print("⛔️ Error updating user data: \(error)")
        }
    }
    
    // Storage 프로필 이미지 데이터 삭제
    private func deleteStorageData(for userId: String) async throws {
        let storageRef = Storage.storage().reference().child("UserProfile/\(userId).jpg")
        
        do {
            try await storageRef.delete()
            print("✅ Profile image successfully deleted for userId: \(userId)")
        } catch let error as NSError {
            if error.code == StorageErrorCode.objectNotFound.rawValue {
                print("⚠️ Profile image not found for userId: \(userId), skipping delete.")
            } else {
                print("⛔️ Error deleting profile image: \(error.localizedDescription)")
                throw error
            }
        }
    }
}
