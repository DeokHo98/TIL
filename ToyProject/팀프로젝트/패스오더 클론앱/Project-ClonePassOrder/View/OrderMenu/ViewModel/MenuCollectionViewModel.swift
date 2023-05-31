//
//  MenuCollectionViewModel.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/17.
//

import Foundation

class MenuCollectionViewModel  {
    
    var orderMenuService : OrderMenuServiceProtocol

    let categoryCellData = CategoryCellData()
    //let categoryArr : [CategoryModel]
    var categoryArr: Observer<[CategoryModel]> = Observer(value: [])
    var categoryServiceError : Observer<OrderMenuServiceError> = Observer(value: .SnapShotError)
    
    let defaultItemIdx : Int = 0
    
    init(service : OrderMenuServiceProtocol = OrderMenuService()) {
        self.orderMenuService = service
        //categoryArr = categoryCellData.getCategoryCelDummyData()
    }
    
    var numberOfCategoryArr: Int {
        //return categoryArr.count
        return categoryArr.value.count
    }
    
    func getCategoryName(index: Int) -> CategoryModel {
        //return categoryArr[index]
        return categoryArr.value[index]
    }
    
    func fetchMenu() {
        orderMenuService.fetchCategory { [weak self] result in
            switch result {
            case .success(let models):
                //print("d:\(models)")
                self?.categoryArr.value = models
            case .failure(let error):
                self?.categoryServiceError.value = error
            }
        }
    }
}
