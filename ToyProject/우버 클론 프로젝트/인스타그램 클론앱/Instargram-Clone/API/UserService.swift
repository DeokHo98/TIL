//
//  UserService.swift
//  Instargram-Clone
//
//  Created by 정덕호 on 2022/04/04.
//

import UIKit
import Firebase


public let COLLECTION_USERS = Firestore.firestore().collection("users")
public let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
public let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")

//현재 로그인한 유저아이디와 일치하는 유저의 정보를 다운받음
struct UserService {
    static func fetchUser(uid: String,completion: @escaping(User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dic = snapshot?.data() else {return}
            let user = User(dic: dic)
            completion(user)
        }
    }
    
    
//현재 모든 사용자를 가져오는 함수
    static func fetchAllUsers(completion: @escaping([User]) -> Void) {
        COLLECTION_USERS.getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            let users = snapshot.documents.map { quary in
                User(dic: quary.data())
            }
            completion(users)
        }
    }
    
    //팔로우를 하는 함수
    static func followUser(uid: String, completion: @escaping(Error?) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).setData([:]) { error in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).setData([:], completion: completion)
        }
    }
    
    //팔로우를 취소하는 함수
    static func unfollowUser(uid: String, completion: @escaping(Error?) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).delete { error in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).delete(completion: completion)
        }
    }
    
    //팔로우 상태인지 아닌지를 확인하는 함수
    static func checkIfUserIsFollowed(uid: String, compliton: @escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).getDocument { snapshot, error in
            guard let isFollowed = snapshot?.exists else {return}
            compliton(isFollowed)
        }
    }
    
    
    static func fetchUserStats(uid: String, completion: @escaping(UserStats) -> Void) {
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { snapshot, error in
            let followers = snapshot?.documents.count ?? 0
            COLLECTION_FOLLOWING.document(uid).collection("user-following").getDocuments { snapshot, error in
                let following = snapshot?.documents.count ?? 0
                COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid).getDocuments { snapshot, error in
                    let posts = snapshot?.documents.count ?? 0
                    
                    completion(UserStats(followers: followers, folllwing: following, posts: posts))
                    
                }
            }
        }
    }
    
}
