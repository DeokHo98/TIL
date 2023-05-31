//
//  Post.swift
//  Instargram-Clone
//
//  Created by 정덕호 on 2022/04/05.
//

import Firebase

struct Post {
    var caption: String
    var likes: Int
    let imageUrl: String
    let ownerUid: String
    let timeStamp: Timestamp
    let postID: String
    let ownerUserName: String
    let ownderImageUrl: String
    var didLike = false
    
    init(postId: String,dic: [String: Any]) {
        self.postID = postId
        self.caption = dic["caption"] as? String ?? ""
        self.likes = dic["likes"] as? Int ?? 0
        self.imageUrl = dic["imageUrl"] as? String ?? ""
        self.ownerUid = dic["ownerUid"] as? String ?? ""
        self.timeStamp = dic["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.ownderImageUrl = dic["ownerImageUrl"] as? String ?? ""
        self.ownerUserName = dic["ownerUsername"] as? String ?? ""
    }
}
