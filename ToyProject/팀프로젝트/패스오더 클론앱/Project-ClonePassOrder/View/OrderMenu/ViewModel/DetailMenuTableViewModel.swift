//
//  DetailMenuTableViewModel.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/18.
//

import Foundation

class DetailMenuTableViewModel {
    
    var orderMenuService : OrderMenuServiceProtocol
    
    var menuArr : Observer<[CafeMenuModel]> = Observer(value: [])
    var allMenuArr : Observer<[[CafeMenuModel]]> = Observer(value: [[]])
    var menuServiceError : Observer<OrderMenuServiceError> = Observer(value: .SnapShotError)
    
    let categoryCellData = CategoryCellData()
    let categoryArr : [CategoryModel]
    
    init(service : OrderMenuServiceProtocol = OrderMenuService()) {
        categoryArr = categoryCellData.getCategoryCelDummyData()
        //categoryArr = MenuCollectionViewModel.shared.categoryArr.value
        self.orderMenuService = service
    }
    
    var numberOfCategoryArrForHeader: Int {
        return categoryArr.count
    }
    
    var numberOfMenuArr : Int {
        return menuArr.value.count
    }
    
    func getNumberOfMenuArr(index: Int) -> Int {
        return allMenuArr.value[index].count
    }
    
    func getCategoryName(index: Int) -> CategoryModel {
        return categoryArr[index]
    }
    
//    func getMenuName(index : Int) -> CafeMenuModel {
//        return menuArr.value[index]
//    }
    
    func getMenuName(section:Int, index: Int) -> CafeMenuModel {
        return allMenuArr.value[section][index]
    }
    
    func fetchMenu(categoris : [String]) {
        var idx : Int = 0
        categoris.forEach {
            orderMenuService.fetchDetails(category: $0) {
                [weak self] result in
                switch result {
                case .success(let models):
                    self?.menuArr.value = models
                    self?.allMenuArr.value.insert(models, at: idx)
                    idx += 1
                    print("allmenu:\(self?.allMenuArr.value)")
                case .failure(let error):
                    self?.menuServiceError.value = error
                }
            }
        }
    }
}
