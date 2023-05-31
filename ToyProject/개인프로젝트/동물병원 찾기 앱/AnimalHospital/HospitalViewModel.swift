//
//  HospitalViewModel.swift
//  AnimalHospital
//
//  Created by 정덕호 on 2022/04/14.
//

import Foundation
import NMapsMap


final class HospitalViewModel {
    

    var models: [HospitalModel] = []
    
    var lodingEnd: () -> Void = {}
    
    func fetch() {
        HospitalService.fetchHospital { [weak self] result in
            switch result {
            case .success(let model):
                self?.models = model
                self?.lodingEnd()
            case .failure(_):
                self?.lodingEnd()
            }
        }
    }
}
