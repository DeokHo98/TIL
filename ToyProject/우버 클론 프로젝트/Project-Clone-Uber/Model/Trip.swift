//
//  File.swift
//  Project-Clone-Uber
//
//  Created by 정덕호 on 2022/03/23.
//

import CoreLocation
import SwiftUI



struct Trip {
    var pickupCoordinates: CLLocationCoordinate2D!
    var destinationCoordinates: CLLocationCoordinate2D!
    let passengerUid: String!
    var driverUid: String?
    var state: TripState!
    
    init(passngerUid: String, dictionary: [String : Any]) {
        self.passengerUid = passngerUid
        
        if let picupCoordinates = dictionary["pickupCoordinates"] as? NSArray {
            guard let lat = picupCoordinates[0] as? CLLocationDegrees else {return}
            guard let long = picupCoordinates[1] as? CLLocationDegrees else {return}
            self.pickupCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        if let destinationCoordinates = dictionary["destinationCoordinates"] as? NSArray {
            guard let lat = destinationCoordinates[0] as? CLLocationDegrees else {return}
            guard let long = destinationCoordinates[1] as? CLLocationDegrees else {return}
            self.destinationCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        self.driverUid = dictionary["driverUid"] as? String ?? ""
        
        if let state = dictionary["state"] as? Int {
            self.state = TripState(rawValue: state)
        }
        
    }
}

enum TripState: Int {
    case requested
    case accepted
    case driverArrived
    case inProgress
    case arrivedAtDestination
    case completed
}
