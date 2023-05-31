//
//  FavoriteViewModel.swift
//  AnimalHospital
//
//  Created by 정덕호 on 2022/04/19.
//

import Foundation

final class FavoriteViewModel {
    
    
    
    var coreDataModels: [Favorite] = []
    
    var count: Int {
        return coreDataModels.count
    }
    
    func fetch() {
        CoreDataService.loadCoreData { [weak self] models in
            self?.coreDataModels = models
        }
    }
}
