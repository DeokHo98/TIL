//
//  Favorite.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/06/14.
//

import Foundation
import Firebase
import Kingfisher

enum FavoriteServiceError: Error {
    case fetchError
    case existsError
    case snapShotError
}

protocol FavoriteServiceProtocol {
    func addFavorite(model: CafeListModel)
    func deleteFavorite(model: CafeListModel)
    func existsFavorite(model: CafeListModel, completion: @escaping (Result<Bool,FavoriteServiceError>) -> Void)
    func fetchFavoriteID(completion: @escaping (Result<[String],FavoriteServiceError>) -> Void)
    func imageFetch(model: CafeListModel, completion: @escaping (Data) -> Void)
    func fetchFavoriteCafeList(ID: [String], completion: @escaping (Result<CafeListModel,FavoriteServiceError>) -> Void)
}


struct FavoriteService: FavoriteServiceProtocol {
    func addFavorite(model: CafeListModel) {
        Firestore.firestore().collection("cafe").document(model.name).updateData(["favoriteCount": model.favoriteCount + 1])
        Firestore.firestore().collection("user").document(Auth.auth().currentUser?.uid ?? "").collection("favorite").document(model.name).setData([:])
    }
    func deleteFavorite(model: CafeListModel) {
        Firestore.firestore().collection("cafe").document(model.name).updateData(["favoriteCount": model.favoriteCount - 1])
        Firestore.firestore().collection("user").document(Auth.auth().currentUser?.uid ?? "").collection("favorite").document(model.name).delete()
    }
    func existsFavorite(model: CafeListModel, completion: @escaping (Result<Bool,FavoriteServiceError>) -> Void) {
        Firestore.firestore().collection("user").document(Auth.auth().currentUser?.uid ?? "").collection("favorite").document(model.name).addSnapshotListener { snapshot, error in
            if error != nil {
                completion(.failure(.existsError))
            } else {
                guard let didFavorite = snapshot?.exists else {
                    completion(.failure(.snapShotError))
                    return
                }
                completion(.success(didFavorite))
            }
        }
    }
    func fetchFavoriteID(completion: @escaping (Result<[String],FavoriteServiceError>) -> Void) {
        Firestore.firestore().collection("user").document(Auth.auth().currentUser?.uid ?? "").collection("favorite").addSnapshotListener { snapshot, error in
            if error != nil {
                completion(.failure(.fetchError))
            } else {
            guard let documets = snapshot?.documents else {
                completion(.failure(.snapShotError))
                return
            }
            let ID = documets.map {
                $0.documentID
            }
            completion(.success(ID))
            }
        }
    }
    func fetchFavoriteCafeList(ID: [String], completion: @escaping (Result<CafeListModel,FavoriteServiceError>) -> Void) {
        ID.forEach {
            Firestore.firestore().collection("cafe").document($0).addSnapshotListener { snapshot, error in
                if  error != nil {
                    completion(.failure(.fetchError))
                } else {
                    guard let doc = snapshot?.data() else {
                        completion(.failure(.snapShotError))
                        return
                    }
                    completion(.success(CafeListModel(
                        name: doc["name"] as? String ?? "",
                        storyCount: doc["storyCount"] as? Int ?? 0,
                        favoriteCount: doc["favoriteCount"] as? Int ?? 0,
                        imageURL: doc["imageURL"] as? String ?? "",
                        lat: doc["lat"] as? Double ?? 0,
                        lon: doc["lon"] as? Double ?? 0,
                        orderTime: doc["orderTime"] as? String ?? "",
                        newTime: doc["newTime"] as? String ?? "",
                        info: doc["info"] as? String ?? "",
                        benefit: doc["benefit"] as? String ?? "",
                        openTime: doc["openTime"] as? String ?? "",
                        offDay: doc["offDay"] as? String ?? "",
                        phoneNumber: doc["phoneNumber"] as? String ?? "",
                        address: doc["address"] as? String ?? ""
                    )
                                       )
                    )
                }
            }
        }
    }
    func imageFetch(model: CafeListModel, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: model.imageURL) else {
            return
        }
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                guard let imageData = value.image.pngData() else {
                    return
                }
                completion(imageData)
            case .failure(_):
                break
            }
        }
    }
}
