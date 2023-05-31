//
//  FavoriteViewModel.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/06/14.
//

import Foundation

final class FavoriteListViewModel {
    
    init(service: FavoriteServiceProtocol = FavoriteService()) {
        self.service = service
    }
    
    var service: FavoriteServiceProtocol
    var items: [CafeListViewModelItem] = []
    var favoriteError: Observer<FavoriteServiceError> = Observer(value: .snapShotError)
    var favoriteBool: Observer<Bool> = Observer(value: false)
    var fetchFavoriteSuccess: Observer<Bool> = Observer(value: false)
    var fetchFavoriteIDSuccess: Observer<[String]> = Observer(value: [])
    
    func count() -> Int {
        self.items.count
    }
    func itemAtIndex(_ index: Int) -> CafeListViewModelItem {
        let item = self.items[index]
        return item
    }
    func fetchFavoriteID() {
        service.fetchFavoriteID { [weak self] result in
            switch result {
            case .success(let ID):
                self!.items = []
                self!.fetchFavoriteIDSuccess.value = ID
            case .failure(let error):
                self?.favoriteError.value = error
            }
        }
    }
    func fetchCafeList(ID: [String]) {
        service.fetchFavoriteCafeList(ID: ID) { [weak self] result in
            switch result {
            case .success(let model):
                let viewModel = CafeListViewModelItem(model: model)
                    self!.service.imageFetch(model: model) { data in
                        viewModel.cellImageData = data
                    }
                self?.items.append(viewModel)
                self?.fetchFavoriteSuccess.value = true
            case .failure(let error):
                self?.favoriteError.value = error
            }
        }
    }
    func addFavorite(model: CafeListModel) {
        service.addFavorite(model: model)
        self.favoriteBool.value = true
    }
    func deleteFavorite(model: CafeListModel) {
        service.deleteFavorite(model: model)
        self.favoriteBool.value = false
    }
    func existsFavorite(model: CafeListModel) {
        service.existsFavorite(model: model) { [weak self] result in
            switch result {
            case .success(let bool):
                self?.favoriteBool.value = bool
            case .failure(let error):
                self?.favoriteError.value = error
            }
        }
    }
    
}
