//
//  User.swift
//  Project-Clone-Uber
//
//  Created by 정덕호 on 2022/03/17.
//

import Foundation
import CoreLocation


enum AccountType: Int {
    case passenger
    case driver
}

struct User {
    let fullName: String
    let email: String
    var accountType: AccountType!
    let uid: String
    var location: CLLocation?
    var homeLocation: String?
    var workLocation: String?
    
    
    init(uid: String,dic: [String: Any]) {
        self.uid = uid
        self.fullName = dic["name"] as? String ?? ""
        self.email = dic["email"] as? String ?? ""
        
        if let home = dic["workLocation"] as? String {
            self.homeLocation = home
        }
        
        if let work = dic["homeLocation"] as? String {
            self.workLocation = work
        }
        
        if let index = dic["accountType"] as? Int {
            self.accountType = AccountType(rawValue: index)
        }
    }
}
