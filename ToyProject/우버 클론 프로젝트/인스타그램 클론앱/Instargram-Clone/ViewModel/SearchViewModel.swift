//
//  SearchViewModel.swift
//  Instargram-Clone
//
//  Created by 정덕호 on 2022/04/05.
//

import Foundation

struct SearchViewModel {
   private let user: User
    
    var fullname: String {
        return user.fullName
    }
    
    var profileImageURL: URL? {
        return URL(string: user.prfileImageUrl)
    }
    
    var userName: String {
        return user.userName
    }
    
    
    init(user: User) {
        self.user = user
    }
}
