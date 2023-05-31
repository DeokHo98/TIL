//
//  DetailViewModel.swift
//  AnimalHospital
//
//  Created by 정덕호 on 2022/04/16.
//

import Foundation
import CoreLocation

final class DetailViewModel {
    
    let model: HospitalModel

    var name: String {
        return model.name
    }
    
    var address: String {
        return model.address
    }
    
    var phoneNumber: String {
        return model.phoneNumber
    }
    
    var callNumber: String {
        return model.phoneNumber.replacingOccurrences(of: "-", with: "")
    }
    
    var runtime: String {
        return model.runtime
    }
    
    var tax: String {
        return model.tax
    }
    
    var imageURL: String {
        return model.imageURL
    }
    
    var x: Double {
        return model.x
    }
    
    var y: Double {
        return model.y
    }
    
    
    init(model: HospitalModel) {
        self.model = model
    }
    
    
    
}
