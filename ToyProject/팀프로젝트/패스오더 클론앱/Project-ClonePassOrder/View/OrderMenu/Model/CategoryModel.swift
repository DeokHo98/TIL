//
//  CategoryModel.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/17.
//

import Foundation

struct CategoryModel {
    var categoryName : String
}

class CategoryCellData {
    func getCategoryCelDummyData() -> [CategoryModel] {
        return  [
            CategoryModel(categoryName: "커피샘플"),
            CategoryModel(categoryName: "음료"),
            CategoryModel(categoryName: "빽스치노"),
            CategoryModel(categoryName: "주스/에이드"),
            CategoryModel(categoryName: "스무디/쉐이크"),
            CategoryModel(categoryName: "차"),
            CategoryModel(categoryName: "블랙펄"),
            CategoryModel(categoryName: "디저트")
        ]
    }
}
