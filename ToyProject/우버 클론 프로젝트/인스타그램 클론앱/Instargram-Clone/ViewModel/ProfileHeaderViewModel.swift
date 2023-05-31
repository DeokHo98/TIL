//
//  ProfileHeaderViewModel.swift
//  Instargram-Clone
//
//  Created by 정덕호 on 2022/04/04.
//

import Foundation
import UIKit

struct ProfileHeaderViewModel {
    //프로필 헤더에 들어가 뷰모델을 만들어줍니다.
    
    let user: User
    
    var fullname: String {
        return user.fullName
    }
    
    var profileImageURL: URL? {
        return URL(string: user.prfileImageUrl)
    }
    
    var followButtonText: String {
        if user.isCurrentUser {
            return "프로필 편집"
        }
        
        return user.isFollowed ? "팔로우 취소" : "팔로우"
    }
    
    var followButtonBackgroundColor: UIColor {
        if user.isCurrentUser {
            return .white
        }
        
        return user.isFollowed ? .white : .systemBlue
    }
    
    var followButtonTextColor: UIColor {
        if user.isCurrentUser {
            return .black
        }
        
        return user.isFollowed ? .black : .white
    }
    
    var numberOfFollowers: NSAttributedString {
        return attributedStatText(value: user.stats.followers, label: "팔로워")
    }
    
    var numberOfFollowings: NSAttributedString {
        return attributedStatText(value: user.stats.folllwing, label: "팔로잉")
    }
    
    var numberOfPosts: NSAttributedString {
        return attributedStatText(value: user.stats.posts, label: "게시글")
    }
    

    
    //어트리뷰트 스트링입니다.
    func attributedStatText(value: Int, label: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: label, attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedText
    }
    
    //유저를 이용해 초기화해줍니다.
    init(user: User) {
        self.user = user
    }
}
