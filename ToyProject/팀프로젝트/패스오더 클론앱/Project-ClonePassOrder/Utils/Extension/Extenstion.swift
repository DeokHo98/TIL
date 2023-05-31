//
//  UIkitExtenstion.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/13.
//

import UIKit
import CoreLocation

extension UIColor {
    static let orderColor = UIColor(displayP3Red: 20/255, green: 45/255, blue: 73/255, alpha: 1)
}

extension UIView {
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.masksToBounds = false
    }
    func getLabelHeight(_ yourLabel : UILabel) -> CGFloat {
        var height = ("1" as! NSString).size(withAttributes: [NSAttributedString.Key.font : yourLabel.font]).height
        return height
    }
}

extension CLLocation {
   static func coordinate() -> CLLocation {
        guard let coordinate2D = CLLocationManager().location?.coordinate else {
            return CLLocation(latitude: 0, longitude: 0)
        }
        return CLLocation(latitude: coordinate2D.latitude, longitude: coordinate2D.longitude)
    }
}
