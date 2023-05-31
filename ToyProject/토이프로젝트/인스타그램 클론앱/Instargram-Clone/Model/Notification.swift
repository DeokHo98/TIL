//
//  Notification.swift
//  Instargram-Clone
//
//  Created by 정덕호 on 2022/04/07.
//

import Firebase

enum NotificationType: Int {
    case like
    case follow
    case comment
    
    var notificationMessage: String {
        switch self {
        case .like:
            return "좋아요를 눌렀습니다"
        case .follow:
            return "당신을 팔로우 했습니다"
        case .comment:
            return "댓글을 남겼습니다"
        }
    }
}

struct Notification {
    let uid: String
    var postImageUrl: String?
    var postid: String?
    let timestapm: Timestamp
    let type: NotificationType
    let id: String
    let userProfileImageUrl: String
    let userName: String
    var userIsFollowed = false
    
    init(dic: [String: Any]) {
        self.timestapm = dic["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.id = dic["id"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
        self.postid = dic["postId"] as? String ?? ""
        self.postImageUrl = dic["postImageUrl"] as? String ?? ""
        self.type = NotificationType(rawValue: dic["type"] as? Int ?? 0) ?? .like
        self.userProfileImageUrl = dic["userProfileImageUrl"] as? String ?? ""
        self.userName = dic["username"] as? String ?? ""
    }
    
}
