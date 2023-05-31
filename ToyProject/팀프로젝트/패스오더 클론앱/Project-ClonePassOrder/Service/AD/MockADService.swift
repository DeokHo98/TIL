//
//  MockADService.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/06/02.
//

import Foundation

struct MockADService: ADServiceProtocol {
    var result: Result<[ADModel], ADServiceError>?
    
    func fetchAD(collectionName: String, completion: @escaping (Result<[ADModel], ADServiceError>) -> Void) {
        completion(result!)
    }
}
