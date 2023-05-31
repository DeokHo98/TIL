//
//  SearchViewModel.swift
//  AnimalHospital
//
//  Created by 정덕호 on 2022/04/14.
//

import Foundation
import NMapsMap

final class SearchViewModel {
    
    var models : [SearchModel] = []
    
    var loddingStart: () -> Void = {}
    
    var lodingEnd: () -> Void = {}
    
    func count() -> Int {
        return models.count
    }
    
    func name(index: Int) -> String {
        return models[index].name.components(separatedBy: ["b","/","<",">"]).joined()
    }
    
    func address(index: Int) -> String {
        return models[index].address
    }
    
    func lating(index: Int) -> NMGLatLng {
        guard let xInt = Int(models[index].x) else {return NMGLatLng()}
        guard let yInt = Int(models[index].y) else {return NMGLatLng()}
        let xDouble = Double(xInt)
        let yDouble = Double(yInt)
        let tm = NMGTm128(x: xDouble, y: yDouble)
        let lating = tm.toLatLng()
        return lating
    }
    
    func fetch(searhText: String) {
        loddingStart()
        SearchService.fetchSearchService(queryValue: searhText) { [weak self] result in
             switch result {
             case .success(let models):
                 self?.models = models
                 self?.lodingEnd()
             case .failure(_):
                 self?.lodingEnd()
             }
        }
    }
}

