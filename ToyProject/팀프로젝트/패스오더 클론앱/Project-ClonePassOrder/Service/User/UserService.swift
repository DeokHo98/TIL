//
//  UserService.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/06/01.
//

import Foundation
import Firebase

enum UserServiceError: Error {
    case currentUserNillError
    case userFetchError
    case snapShotError
}

protocol UserServiceProtocol {
    func fetch(completion: @escaping (Result<UserModel,UserServiceError>) -> Void)
}

struct UserService: UserServiceProtocol {
    func fetch(completion: @escaping (Result<UserModel, UserServiceError>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(.currentUserNillError))
            return
        }
        Firestore.firestore().collection("user").document(uid).getDocument { snapshot, error in
            if error != nil {
                completion(.failure(.userFetchError))
            } else {
                guard let dic = snapshot?.data() else {
                    completion(.failure(.snapShotError))
                    return
                }
                let model = UserModel(
                    userName: dic["userName"] as? String ?? "",
                    email: dic["email"] as? String ?? "",
                    profileImageUrl: dic["profileImageURL"] as? String ?? ""
                )
                completion(.success(model))
            }
        }
    }
  
}
