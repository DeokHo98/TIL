//
//  PostService.swift
//  Instargram-Clone
//
//  Created by 정덕호 on 2022/04/05.
//

import Firebase
import UIKit
import AVFoundation

public let COLLECTION_POSTS = Firestore.firestore().collection("posts")

struct PostService {
    static func uploadPost(caption: String, image: UIImage,user: User,completion: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { imageUrl in
            let data = ["caption": caption, "timestamp": Timestamp(date: Date()),"likes": 0, "imageUrl": imageUrl, "ownerUid": uid,"ownerImageUrl": user.prfileImageUrl,"ownerUsername": user.userName ] as [String : Any]
            
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
        }
    }
    
    static func fetchPosts(compltion: @escaping ([Post]) -> Void) {
        COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {return}
            let posts = documents.map {
                Post(postId: $0.documentID, dic: $0.data())
            }
            compltion(posts)
        }
    }
    
    static func fetchPosts(forUser uid: String, completion: @escaping ([Post]) -> Void) {
        let query = COLLECTION_POSTS
            .whereField("ownerUid", isEqualTo: uid)

        
        
        query.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {return}
            
            var posts = documents.map {
                Post(postId: $0.documentID, dic: $0.data())
            }
            posts.sort {
                return $0.timeStamp.seconds > $1.timeStamp.seconds
            }
            
            completion(posts)
        }
    }
    
    static func likePost(post: Post, completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        COLLECTION_POSTS.document(post.postID).updateData(["likes": post.likes + 1])
        
        COLLECTION_POSTS.document(post.postID).collection("post-likes").document(uid).setData([:]) { _ in
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postID).setData([:], completion: completion)
        }
    }
    
    static func unlikePost(post: Post, completion: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        guard post.likes > 0 else {return}
        
        COLLECTION_POSTS.document(post.postID).updateData(["likes": post.likes - 1])
        
        COLLECTION_POSTS.document(post.postID).collection("post-likes").document(uid).delete { error in
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postID).delete(completion: completion)
        }
        
    }
    
    static func checkIfUserLikedPost(post: Post, completion: @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        COLLECTION_USERS.document(uid).collection("user-likes").document(post.postID).getDocument { snapshot, error in
            guard let didLike = snapshot?.exists else {return}
            completion(didLike) 
        }
    }
    
    static func fetchPost(withPostId postid: String, completion: @escaping(Post) -> Void) {
        COLLECTION_POSTS.document(postid).getDocument { snapshot, error in
            guard let snapshot = snapshot else {return}
            guard let data = snapshot.data() else {return}
            let post = Post(postId: snapshot.documentID, dic: data)
            completion(post)
        }
    }
    
 
    
   
}

