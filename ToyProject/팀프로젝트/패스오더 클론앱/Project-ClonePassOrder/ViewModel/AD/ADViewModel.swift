//
//  ADViewModel.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/06/02.
//

import Foundation

//MARK: - List

final class ADListViewModel {
    
    init(service: ADServiceProtocol = ADService()) {
        self.adService = service
    }
    
    var adService: ADServiceProtocol
    
    var items: [ADViewModelItem] = []
    var ADfetchEnd: Observer<Bool> = Observer(value: false)
    var ADServiceError: Observer<ADServiceError> = Observer(value: .snapShotError)
}

extension ADListViewModel {
    
    func count() -> Int {
        self.items.count
    }
    func itemAtIndex(_ index: Int) -> ADViewModelItem {
        let item = self.items[index]
        return item
    }
    func fetchAD(collectionName: String) {
        adService.fetchAD(collectionName: collectionName) { [weak self] result in
            switch result {
            case .success(let models):
                let items = models.map {
                    ADViewModelItem(model: $0)
                }
                self?.items = items
                self?.ADfetchEnd.value = true
            case .failure(let error):
                self?.ADServiceError.value = error
            }
        }
    }
}

//MARK: - item

final class ADViewModelItem {
    
    init(model: ADModel) {
        self.model = model
    }
    
    var model: ADModel
    
    var ADImageURL: URL? {
        return URL(string: model.ADImageUrl)
    }
}


extension ADViewModelItem: Equatable {
    static func == (lhs: ADViewModelItem, rhs: ADViewModelItem) -> Bool {
        lhs.ADImageURL == lhs.ADImageURL
    }
}
