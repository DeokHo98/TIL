//
//  MockSignUpService.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/31.
//

import Foundation

struct MockSignUpService: SignUpServiceProtocol {
    
    var result: Result<Void, SigunUpError>?
    var phoneAuthResult: Result<String, SigunUpError>?
    var credentialAuthResult: Result<Bool, SigunUpError>?
    
    
    func signUp(model: SignUpModel, completion: @escaping (Result<Void, SigunUpError>) -> Void) {
        completion(result!)
    }
    func phoneAuth(phoneNumber: String, completion: @escaping (Result<String, SigunUpError>) -> Void) {
        completion(phoneAuthResult!)
    }
    
    func credentialAuth(verificationID: String, verificationcode: String, completion: @escaping (Result<Bool, SigunUpError>) -> Void) {
        completion(credentialAuthResult!)
    }
 
    
}
