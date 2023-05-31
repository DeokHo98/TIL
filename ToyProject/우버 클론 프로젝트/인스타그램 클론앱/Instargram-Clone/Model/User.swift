//
//  User.swift
//  Instargram-Clone
//
//  Created by 정덕호 on 2022/04/04.
//

import Foundation
import Firebase

struct User {
    let email: String
    let fullName: String
    let prfileImageUrl: String
    let userName: String
    let uid: String
    
    var isFollowed = false
    
    var stats: UserStats!
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid}
    
    init(dic: [String: Any]) {
        self.email = dic["email"] as? String ?? ""
        self.fullName = dic["fullname"] as? String ?? ""
        self.prfileImageUrl = dic["profileImageUrl"] as? String ?? ""
        self.userName = dic["username"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
        self.stats = UserStats(followers: 0, folllwing: 0, posts: 0)
    }
}

struct UserStats {
    let followers: Int
    let folllwing: Int
    let posts: Int
}
