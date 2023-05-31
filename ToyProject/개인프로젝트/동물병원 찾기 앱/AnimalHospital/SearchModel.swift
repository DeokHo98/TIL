//
//  SearchModel.swift
//  AnimalHospital
//
//  Created by 정덕호 on 2022/04/14.
//

import Foundation

import Foundation

// MARK: - SearchModel
struct SearchModelList: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [SearchModelItems]
}

// MARK: - Item
struct SearchModelItems: Codable {
    let title: String
    let link: String
    let category, itemDescription, telephone, address: String
    let roadAddress, mapx, mapy: String
    
    enum CodingKeys: String, CodingKey {
        case title, link, category
        case itemDescription = "description"
        case telephone, address, roadAddress, mapx, mapy
    }
}


struct SearchModel {
    let name: String
    let address: String
    let x: String
    let y: String
    
    init(name: String, address: String, x: String, y: String) {
        self.name = name
        self.address = address
        self.x = x
        self.y = y
    }
    
}

