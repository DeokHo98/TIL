//
//  SignUpModel.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/31.
//

import Foundation

struct SignUpModel {
    var email: String
    var password: String
    var confirmPssword: String
    var phoneNumber: String
    var verificationCode: String
    var profileImageURL: String
    var userName: String
    var is14YearsOld: Bool
    var isAgreeService: Bool
    var isAgreeLocationService: Bool
    var isAgreePrivacyInformation: Bool
    var isAgreePrivacyThirdPartyInformation: Bool
    var isAgreeMarketingReceive: Bool
    
    var imageData: Data?
}

extension SignUpModel {
    static let EMPTY = SignUpModel(
        email: "",
        password: "",
        confirmPssword: "",
        phoneNumber: "",
        verificationCode: "",
        profileImageURL: "",
        userName: "",
        is14YearsOld: false,
        isAgreeService: false,
        isAgreeLocationService: false,
        isAgreePrivacyInformation: false,
        isAgreePrivacyThirdPartyInformation: false,
        isAgreeMarketingReceive: false
    )
}
