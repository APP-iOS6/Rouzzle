//
//  UserService.swift
//  Rouzzle
//
//  Created by 김동경 on 11/5/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

protocol UserServiceType {
    func uploadUserData(_ userUid: String, user: RoutineUser) async -> Result<Void, Error>
    func fetchUserData(_ userUid: String) async -> Result<RoutineUser, Error>
    func uploadProfileImage(_ image: UIImage, userUid: String) async -> Result<String, Error>
    func loadProfileImage(from urlString: String) async -> Result<UIImage, Error>
}

class UserService: UserServiceType {
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    /// 유저 데이터를 FireStore User컬렉션에 등록하는 함수
    func uploadUserData(_ userUid: String, user: RoutineUser) async -> Result<Void, Error> {
        do {
            let userEncodeData = try Firestore.Encoder().encode(user)
            try await self.db.collection("User").document(userUid).setData(userEncodeData, merge: true)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    /// FireStore User컬렉션에 등록된 유저 데이터를 불러오는 함수
    func fetchUserData(_ userUid: String) async -> Result<RoutineUser, Error> {
        do {
            let document = try await db.collection("User").document(userUid).getDocument(source: .server)
            let user = try document.data(as: RoutineUser.self)
            return .success(user)
        } catch {
            return .failure(error)
        }
    }
    
    /// Firebase Storage에 프로필 이미지를 업로드하고 URL을 반환하는 함수
    func uploadProfileImage(_ image: UIImage, userUid: String) async -> Result<String, Error> {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            return .failure(NSError(domain: "ImageConversionError", code: -1, userInfo: nil))
        }
        
        let imageRef = storage.reference().child("UserProfile/\(userUid).jpg")
        
        do {
            _ = try await imageRef.putDataAsync(imageData)
            let url = try await imageRef.downloadURL()
            return .success(url.absoluteString)
        } catch {
            return .failure(error)
        }
    }
    
    /// Firebase Storage에서 URL을 통해 프로필 이미지를 로드하는 함수
    func loadProfileImage(from urlString: String) async -> Result<UIImage, Error> {
        guard !urlString.isEmpty else {
            return .failure(NSError(domain: "URL Error", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL is empty"]))
        }
        
        let storageRef = storage.reference(forURL: urlString)
        
        do {
            let data = try await storageRef.data(maxSize: 5 * 1024 * 1024) // 5MB 제한
            if let image = UIImage(data: data) {
                return .success(image)
            } else {
                return .failure(NSError(domain: "Image Conversion Error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert data to UIImage"]))
            }
        } catch {
            return .failure(error)
        }
    }
}
