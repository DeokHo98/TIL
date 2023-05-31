//
//  ADService.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/06/02.
//

import Foundation
import Firebase

enum ADServiceError: Error {
    case ADFetchError
    case snapShotError
}

protocol ADServiceProtocol {
    func fetchAD(
        collectionName: String,
        completion: @escaping (Result<[ADModel], ADServiceError>) -> Void)
}

struct ADService: ADServiceProtocol {
    func fetchAD(
        collectionName: String,
        completion: @escaping (Result<[ADModel], ADServiceError>) -> Void
    ) {
        Firestore.firestore().collection(collectionName).getDocuments { snapShot, error in
            if error != nil {
                completion(.failure(.ADFetchError))
            } else {
                guard let documents = snapShot?.documents else {
                    completion(.failure(.snapShotError))
                    return
                }
                let models = documents.map {
                    ADModel(ADImageUrl: $0.data()["URL"] as? String ?? "")
                }
                completion(.success(models))
            }
        }
    }
}
