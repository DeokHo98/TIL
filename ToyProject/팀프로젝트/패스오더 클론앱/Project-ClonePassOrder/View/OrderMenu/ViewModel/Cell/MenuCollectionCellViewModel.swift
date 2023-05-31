//
//  MenuCollectionCellViewModel.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/06/14.
//

import Foundation

class MenuCollectionCellViewModel {
    func changeDataFormat(_ model : CategoryModel) -> CategoryModel {
        var categoryName = model.categoryName
        let startIndex = categoryName.index(categoryName.startIndex, offsetBy: 1)
        let range = startIndex...
        categoryName = String(categoryName[range])
        let fianlCategoryName = categoryName.replacingOccurrences(of: ",", with: "/ ")
        return CategoryModel(categoryName: fianlCategoryName)
    }
}
