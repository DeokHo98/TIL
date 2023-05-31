//
//  HospitalModel.swift
//  AnimalHospital
//
//  Created by 정덕호 on 2022/04/14.
//

import Foundation

struct HospitalModel {
    var name: String
    var address: String
    var phoneNumber: String
    var runtime: String
    var imageURL: String
    var tax: String
    var x: Double
    var y: Double
    
    init(dic: [String: Any]) {
        self.name = dic["name"] as? String ?? ""
        self.address = dic["address"] as? String ?? ""
        self.phoneNumber = dic["phoneNumber"] as? String ?? ""
        self.runtime = dic["runtime"] as? String ?? ""
        self.imageURL = dic["image"] as? String ?? "이미지 없음"
        self.tax = dic["tax"] as? String ?? "야간 할증 정보가 없습니다"
        self.x = dic["x"] as? Double ?? 0
        self.y = dic["y"] as? Double ?? 0
    }
}
