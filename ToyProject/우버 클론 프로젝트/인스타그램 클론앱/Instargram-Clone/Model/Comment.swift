//
//  File.swift
//  Instargram-Clone
//
//  Created by 정덕호 on 2022/04/06.
//

import Firebase

struct Comment {
    let uid: String
    let username: String
    let profileimageUrl: String
    let timesteapm: Timestamp
    let commentText: String
    
    init(dic: [String: Any]) {
        self.uid = dic["uid"] as? String ?? ""
        self.username = dic["username"] as? String ?? ""
        self.profileimageUrl = dic["profileImageUrl"] as? String ?? ""
        self.commentText = dic["comment"] as? String ?? ""
        self.timesteapm = dic["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
