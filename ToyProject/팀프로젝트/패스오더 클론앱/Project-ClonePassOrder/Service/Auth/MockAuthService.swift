//
//  MockAuthService.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/30.
//

import Foundation

struct MockAuthService: AuthServiceProtocol {
    
    var result: Result<Void, AuthError>?
    
    func login(
        model: AuthModel,
        completion: @escaping (Result<Void, AuthError>) -> Void
    ) {
        completion(result!)
    }
    func logout(completion: @escaping (Result<Void, AuthError>) -> Void) throws {
        completion(result!)
    }
    
}
