//
//  Service.swift
//  Project-Clone-Uber
//
//  Created by 정덕호 on 2022/03/17.
//

import Firebase
import CoreLocation
import GeoFire

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_DRIVER_LOCATIONS = DB_REF.child("driver-location")
let REF_TRIPS = DB_REF.child("trip")

struct DriverService {
    static let shared = DriverService()
    
    func observeTrips(compliton: @escaping (Trip) -> Void) {
        REF_TRIPS.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            let uid = snapshot.key
            let trip = Trip(passngerUid: uid, dictionary: dictionary)
            compliton(trip)
        }
    }
    
    func observeTripCancelled(trip: Trip, compliton:@escaping() -> Void) {
        REF_TRIPS.child(trip.passengerUid).observeSingleEvent(of: .childRemoved) { _ in
            compliton()
        }
    }
    
    
    func acceptTrip(trip: Trip, completion: @escaping (Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let values = ["driverUid": uid, "state": TripState.accepted.rawValue] as [String : Any]
        
        REF_TRIPS.child(trip.passengerUid).updateChildValues(values, withCompletionBlock: completion)
    }
    
    func updateTripState(trip: Trip, state: TripState, completion: @escaping (Error?, DatabaseReference) -> Void) {
        REF_TRIPS.child(trip.passengerUid).child("state").setValue(state.rawValue, withCompletionBlock: completion)
        
        if state == .completed {
            REF_TRIPS.child(trip.passengerUid).removeAllObservers()
        }
    }
    
    
    
    
    func updateDriverLocation(location: CLLocation) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
        geofire.setLocation(location, forKey: uid)
    }
    
    
    func saveLocation(locationString: String, type: locationType, completion: @escaping(Error?,DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let key: String = type == .home ? "homeLocation" : "workLocation"
        REF_USERS.child(uid).child(key).setValue(locationString, withCompletionBlock: completion)
    }
}




struct PassengrService {
    static let shared = PassengrService()
    
    func fetchDriver(location: CLLocation, complition: @escaping(User) -> Void) {
        let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
        
        REF_DRIVER_LOCATIONS.observe(.value) { snapshot in
            geofire.query(at: location, withRadius: 50).observe(.keyEntered, with: { uid, loca in
                Service.shared.fetchData(uid: uid) { user in
                    var driver = user
                    driver.location = loca
                    complition(driver)
                }
            })
        }
    }
    
    
    
    func uploadTrip(pickupCoordinates: CLLocationCoordinate2D, destinationCoodinates: CLLocationCoordinate2D, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let pickupArray = [pickupCoordinates.latitude, pickupCoordinates.longitude]
        let desinationArray = [destinationCoodinates.latitude, destinationCoodinates.longitude]
        
        let values = ["pickupCoordinates": pickupArray, "destinationCoordinates":desinationArray, "state": TripState.requested.rawValue] as [String : Any]
        
        REF_TRIPS.child(uid).updateChildValues(values, withCompletionBlock: completion)
    }
    
    
    func observCurrentTrip(compliton: @escaping(Trip) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        REF_TRIPS.child(uid).observe(.value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else {return}
                    let uid = snapshot.key
                    let trip = Trip(passngerUid: uid, dictionary: dictionary)
                    compliton(trip)
        }
    }
    
    
    
    
    func deletTrip(completion: @escaping (Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        REF_TRIPS.child(uid).removeValue(completionBlock: completion)
        
    }
    
}


struct Service {

    static let shared = Service()
    let uid = Auth.auth().currentUser?.uid
    
    func fetchData(uid: String,completion: @escaping (User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            let uid = snapshot.key
            let user = User(uid: uid, dic: dictionary)
            completion(user)
            
        }
    }
    

 
    
    
    
}


