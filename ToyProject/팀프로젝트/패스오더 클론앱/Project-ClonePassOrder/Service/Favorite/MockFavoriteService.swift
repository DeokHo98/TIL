//
//  MockFavoriteService.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/06/14.
//

import Foundation

struct MockFavoriteService: FavoriteServiceProtocol {
    
    var existsResult: Result<Bool, FavoriteServiceError>?
    var fetchIDResult: Result<[String], FavoriteServiceError>?
    var fetchCafeListResult: Result<CafeListModel, FavoriteServiceError>?
    
    func addFavorite(model: CafeListModel) {
        
    }
    
    func deleteFavorite(model: CafeListModel) {
        
    }
    
    func existsFavorite(model: CafeListModel, completion: @escaping (Result<Bool, FavoriteServiceError>) -> Void) {
        completion(existsResult!)
    }
    
    func fetchFavoriteID(completion: @escaping (Result<[String], FavoriteServiceError>) -> Void) {
        completion(fetchIDResult!)
    }
    func fetchFavoriteCafeList(ID: [String], completion: @escaping (Result<CafeListModel, FavoriteServiceError>) -> Void) {
        completion(fetchCafeListResult!)
    }
    func imageFetch(model: CafeListModel, completion: @escaping (Data) -> Void) {
        completion(Data())
    }
}
