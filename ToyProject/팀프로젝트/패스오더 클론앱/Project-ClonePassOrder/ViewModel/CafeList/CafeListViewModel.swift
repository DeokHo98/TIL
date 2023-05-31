//
//  CafeViewModel.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/06/03.
//

import Foundation
import CoreLocation
import Kingfisher

//MARK: - List

final class CafeListViewModel {
    
    init(service: CafeListServicePorotocol = CafeListService()) {
        self.cafeSerivce = service
    }
    
    var cafeSerivce: CafeListServicePorotocol
    var items: [CafeListViewModelItem] = []
    var cafeServiceError: Observer<CafeListServiceError> = Observer(value: .snapShotError)
    var cafeFetchEnd: Observer<Bool> = Observer(value: false)
}

extension CafeListViewModel {
    
    func count() -> Int {
        self.items.count
    }
    func itemAtIndex(_ index: Int) -> CafeListViewModelItem {
        let item = self.items[index]
        return item
    }
    func orderNearStore(coodinate: CLLocation) -> [CafeListViewModelItem] {
       let items = items.sorted {
           $0.distance(coordinate: coodinate) < $1.distance(coordinate: coodinate)
        }
        return items
    }
    func orderManyStoryStore() -> [CafeListViewModelItem] {
        let items = items.sorted {
            $0.storyCount > $1.storyCount
        }
        return items
    }
    func
    orderNewStore(coodinate: CLLocation) -> [CafeListViewModelItem] {
        let items = items.sorted {
             $0.distance(coordinate: coodinate)  < $1.distance(coordinate: coodinate)
        }.filter {
            return $0.newTime == "신규매장"
        }
        return items
    }
    func searchCafe(text: String) -> [CafeListViewModelItem] {
        let items = items.filter {
            $0.name.contains(text)
        }
        return items
    }
    func fetchCafe() {
        cafeSerivce.fetchCafe { [weak self] result in
            switch result {
            case .success(let models):
                let items = models.map {
                    CafeListViewModelItem(model: $0)
                }
               items.forEach { item in
                   self!.cafeSerivce.imageFetch(model: item.model) { data in
                       item.cellImageData = data
                   }
                }
                self!.items = items
                self!.cafeFetchEnd.value = true
            case .failure(let error):
                self?.cafeServiceError.value = error
            }
        }
    }
    
}

//MARK: - item

final class CafeListViewModelItem: Equatable {
    static func == (lhs: CafeListViewModelItem, rhs: CafeListViewModelItem) -> Bool {
        lhs.name == rhs.name &&
        lhs.storyCount == rhs.storyCount &&
        lhs.favoriteCount == rhs.favoriteCount &&
        lhs.orderTime == rhs.orderTime &&
        lhs.model == rhs.model &&
        lhs.address == rhs.address &&
        lhs.phoneNumber == rhs.phoneNumber &&
        lhs.lon == rhs.lon &&
        lhs.lat == rhs.lat &&
        lhs.benefit == rhs.benefit
    }
    
    
    init(model: CafeListModel) {
        self.model = model
    }
    
    var model: CafeListModel
    var cellImageData: Data?
    var name: String {
       return model.name
    }
    var storyCount: Int {
        return model.storyCount
    }
    var favoriteCount: Int {
        return model.favoriteCount
    }
    var orderTime: String {
        return model.orderTime
    }
    var newTime: String {
        return model.newTime
    }
    var info: String {
        return model.info
    }
    var benefit: String {
        return model.benefit
    }
    var openTime: String {
        return model.openTime
    }
    var offDay: String {
        return model.offDay
    }
    var phoneNumber: String {
        return model.phoneNumber
    }
    var lat: Double {
        return model.lat
    }
    var lon: Double {
        return model.lon
    }
    var address: String {
        return model.address
    }
    func distanceString(coordinate: CLLocation) -> String {
        let userCoordinate = coordinate
        let cafeCoordinate = CLLocation(latitude: model.lat, longitude: model.lon)
        let distance = userCoordinate.distance(from: cafeCoordinate)
        if Int(distance) < 1000 {
            return  "\(Int(distance))m"
        } else {
            return String(format: "%.2f", Double(distance) / 1000) + "km"
        }
    }
    func distance(coordinate: CLLocation) -> Int {
        let userCoordinate = coordinate
        let cafeCoordinate = CLLocation(latitude: model.lat, longitude: model.lon)
        let distance = userCoordinate.distance(from: cafeCoordinate)
        return Int(distance)
    }
}
