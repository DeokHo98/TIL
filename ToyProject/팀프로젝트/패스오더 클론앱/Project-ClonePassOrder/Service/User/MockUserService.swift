//
//  MockUserService.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/06/01.
//

import Foundation

struct MockUserService: UserServiceProtocol {
    
    var result: Result<UserModel, UserServiceError>?
    
    func fetch(completion: @escaping (Result<UserModel, UserServiceError>) -> Void) {
        completion(result!)
    }
    
    
}
