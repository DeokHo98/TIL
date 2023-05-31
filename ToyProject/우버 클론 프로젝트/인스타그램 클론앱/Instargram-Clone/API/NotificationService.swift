//
//  NotificationService.swift
//  Instargram-Clone
//
//  Created by 정덕호 on 2022/04/07.
//

import Firebase

public let COLLECTION_NORIFICATIONS = Firestore.firestore().collection("notifications")

struct NotificationService {
    static func uploadNotification(uid: String,fromUser: User, type: NotificationType, post: Post? = nil) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard uid != currentUid else { return }
        
        
        let docRef = COLLECTION_NORIFICATIONS.document(uid).collection("user-norifications").document()
        
        var data: [String: Any] = ["timestamp": Timestamp(date: Date())
                                   ,"uid": fromUser.uid
                                   ,"type": type.rawValue
                                   ,"id": docRef.documentID
                                   ,"userProfileImageUrl" : fromUser.prfileImageUrl
                                   ,"username": fromUser.userName
        ]
        
        if let post = post {
            data["postId"] = post.postID
            data["postImageUrl"] = post.imageUrl
        }
        
        
        docRef.setData(data)
        
    }
    
    static func fetchNotification(completion: @escaping([Notification]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_NORIFICATIONS.document(uid).collection("user-norifications").getDocuments { snapshot, error in
            guard let document = snapshot?.documents else {return}
            
            let notifications = document.map {
                Notification(dic: $0.data())
            }
            completion(notifications)
        }
        
    }
}
