//
//  UserModel.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/06/01.
//

import Foundation

struct UserModel: Equatable {
    var userName: String
    var email: String
    var profileImageUrl: String
}

extension UserModel {
    static let EMPTY = UserModel(userName: "", email: "", profileImageUrl: "")
}
