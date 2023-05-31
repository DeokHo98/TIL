//
//  OrderMenuService.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/06/13.
//

import Foundation
import Firebase

enum OrderMenuServiceError : Error {
    case MenuFetchError
    case SnapShotError
}
protocol OrderMenuServiceProtocol {
    func fetchCategory(completion: @escaping (Result<[CategoryModel], OrderMenuServiceError>) -> Void)
    func fetchDetails(category: String, completion: @escaping (Result<[CafeMenuModel],OrderMenuServiceError>) -> Void)
}

struct OrderMenuService : OrderMenuServiceProtocol {
    func fetchCategory(completion: @escaping (Result<[CategoryModel], OrderMenuServiceError>) -> Void) {
        Firestore.firestore().collection("빽다방 동두천지행점").order(by: "id").getDocuments { snapshot, error in
            if error != nil {
                completion(.failure(.MenuFetchError))
            } else {
                guard let documtes = snapshot?.documents else { completion(.failure(.SnapShotError))
                    return
                }
                let models = documtes.map {
                    CategoryModel(categoryName: $0.documentID)
                }
                completion(.success(models))
            }
        }
    }
    func fetchDetails(category: String, completion: @escaping (Result<[CafeMenuModel], OrderMenuServiceError>) -> Void) {
        Firestore.firestore().collection("빽다방 동두천지행점").document(category).collection("menu").order(by: "id").getDocuments { snapshot, error in
            if error != nil {
                completion(.failure(.MenuFetchError))
            } else {
                guard let documents = snapshot?.documents else {
                    completion(.failure(.SnapShotError))
                    return
                }
                let models = documents.map {
                    CafeMenuModel(
                        itemName: $0.documentID,
                        imageURL: $0.data()["imageURL"] as? String ?? "",
                        price: $0.data()["price"] as? String ?? "",
                        options1: $0.data()["options1"] as? [String] ?? [],
                        options2: $0.data()["options2"] as? [String] ?? []
                    )
                }
                completion(.success(models))
            }
        }
    }
}
