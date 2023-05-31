//
//  DriverAnnetaiton.swift
//  Project-Clone-Uber
//
//  Created by 정덕호 on 2022/03/23.
//

import MapKit

class DriverAnnotation: NSObject, MKAnnotation {
    static let annotationIdentified = "DriverAnno"
    
   dynamic var coordinate: CLLocationCoordinate2D
    var uid: String
    
    init(uid: String, corrdinate: CLLocationCoordinate2D) {
        self.uid = uid
        self.coordinate = corrdinate
    }
    
    
    func updateAnnotationPosition(withCoordinate coordinate: CLLocationCoordinate2D) {
        UIView.animate(withDuration: 1) {
            self.coordinate = coordinate
        }
    }
    
}
