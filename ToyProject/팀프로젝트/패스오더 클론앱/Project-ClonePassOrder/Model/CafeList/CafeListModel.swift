//
//  CafeModel.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/06/03.
//

import Foundation

struct CafeListModel: Equatable {
    var name: String
    var storyCount: Int
    var favoriteCount: Int
    var imageURL: String
    var lat: Double
    var lon: Double
    var orderTime: String
    var newTime: String
    let info: String
    let benefit: String
    let openTime: String
    let offDay: String
    let phoneNumber: String
    let address: String
}

extension CafeListModel {
    static let EMPTY = CafeListModel(name: "", storyCount: 0, favoriteCount: 0, imageURL: "", lat: 0, lon: 0, orderTime: "", newTime: "", info: "", benefit: "", openTime: "", offDay: "", phoneNumber: "", address: "")
}
