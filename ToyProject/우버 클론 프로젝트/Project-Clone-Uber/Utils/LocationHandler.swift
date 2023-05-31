//
//  LocationHandler.swift
//  Project-Clone-Uber
//
//  Created by 정덕호 on 2022/03/23.
//

import UIKit
import CoreLocation

class LocationHnadler: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationHnadler()
    var locationManager: CLLocationManager!
    var location: CLLocation?
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }
}
