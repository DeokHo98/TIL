//
//  AuthModel.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/31.
//

import Foundation

struct AuthModel {
    var email: String
    var password: String
}

extension AuthModel {
    static let EMPTY = AuthModel(email: "", password: "")
}
