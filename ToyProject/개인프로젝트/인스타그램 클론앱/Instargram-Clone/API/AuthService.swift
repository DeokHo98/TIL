//
//  AuthService.swift
//  Instargram-Clone
//
//  Created by 정덕호 on 2022/03/30.
//

import Firebase
import UIKit




struct AuthService {
    //로그인 메서드 입니다.
    static func logUserIn(email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
        
    }
    
    static func registerUser(credentials: AuthCredentials, completion: @escaping(Error?) -> Void) {
        //구조화 시킨 데이터의 이미지를 ImageUploader 메서드를 이용해 파이어베이스 스토리지에 저장합니다.
        ImageUploader.uploadImage(image: credentials.profileImage) { imageurl in
            //파이어베이스에 새로운 유저 데이터를 만듭니다.
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                if error != nil {
                    print("회원가입 에러")
                    return
                }
                
                //[String: Any] 타입의 데이터를 파이어스토어에 저장합니다.
                guard let uid = result?.user.uid else { return }
                let data: [String: Any] = ["email": credentials.email,"fullname": credentials.fullName, "profileImageUrl": imageurl, "uid": uid, "username": credentials.userName]
                
                Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
                
            }
        }
    }
}
