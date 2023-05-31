//
//  MockImageUploaderService.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/31.
//

import Foundation

struct MockImageUploaderService: ImageUploaderServiceProtocol {
    
    var result: Result<String, ImageUploaderError>?
    
    func uploadImage(
        fileName: String,
        imageData: Data,
        completion: @escaping (Result<String, ImageUploaderError>) -> Void) {
        completion(result!)
    }
    
    
}
