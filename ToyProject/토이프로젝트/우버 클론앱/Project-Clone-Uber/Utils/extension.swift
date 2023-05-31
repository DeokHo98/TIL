//
//  extension.swift
//  Project-Clone-Uber
//
//  Created by 정덕호 on 2022/03/06.
//

import Foundation
import UIKit
import MapKit

extension UIColor {
    static let backgroundColor = UIColor(displayP3Red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
}

extension UIView {
    
    static func inputContainerView(imageView: UIImageView, texField: UITextField) -> UIView {
        let view = UIView()
    
        view.addSubview(imageView)
        imageView.centerY(inView: view)
        imageView.anchor(leading: view.leadingAnchor, paddingLeading: 8,width: 24, height: 24)
        
        view.addSubview(texField)
        texField.centerY(inView: view)
        texField.anchor(leading: imageView.trailingAnchor,bottom: view.bottomAnchor,trailng: view.trailingAnchor,paddingLeading: 8,paddingTrailing: 8)
        
        let separatorView: UIView = {
            let separator = UIView()
            separator.backgroundColor = .lightGray
            return separator
        }()
        
        view.addSubview(separatorView)
        separatorView.anchor(leading: view.leadingAnchor, bottom: view.bottomAnchor, trailng: view.trailingAnchor,paddingLeading: 8, height: 0.75)

      
        
        
        return view
    }
    
    
    func anchor(top: NSLayoutYAxisAnchor? = nil,leading: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, trailng: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat = 0, paddingLeading: CGFloat = 0, paddingBottom: CGFloat = 0, paddingTrailing: CGFloat = 0, width: CGFloat? = nil, height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: paddingLeading).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let trailng = trailng {
            trailingAnchor.constraint(equalTo: trailng, constant: -paddingTrailing).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func centerX(inView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        if let left = leftAnchor {
            anchor(leading: left, paddingLeading: paddingLeft)
        }
    }
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.55
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.masksToBounds = false
    }
}


extension UITextField {
    
    static func textField(plachHolderName: String, isSecureText: Bool) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.keyboardAppearance = .dark
        textField.isSecureTextEntry = isSecureText
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: plachHolderName,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        return textField
    }
    
}

extension UIImageView {
    static func imageView(imageName: String, alpha: CGFloat = 1) -> UIImageView {
        let image = UIImageView()
        image.image = UIImage(named: imageName)
        image.alpha = alpha
        return image
    }
}

extension UIButton {
   static func loginButton(buttonLabel: String) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        button.setTitle(buttonLabel, for: .normal)
        button.setTitleColor(UIColor(white: 1, alpha: 1), for: .normal)
        button.layer.cornerRadius = 5
        button.anchor(height: 50)
        button.titleLabel?.font = .systemFont(ofSize: 24)
        return button
    }
    
    static func textButton(text1: String, text2: String) -> UIButton{
             let button = UIButton(type: .system)
             let attributedTitle = NSMutableAttributedString(string: text1, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
             attributedTitle.append(NSAttributedString(string: text2, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.systemBlue]))
             button.setAttributedTitle(attributedTitle, for: .normal)
             return button
    }
}

extension UILabel {
    static func uberTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = "UBER"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = .white
        return label
    }
}

extension UIImage {
    func resizeImage(image: UIImage,height: CGFloat, width: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}


extension MKPlacemark {
    var address: String? {
        get {
            guard let subthorughtfare = subThoroughfare else { return nil}
            guard let thoroughtfare = thoroughfare else { return nil}
            guard let locality = locality else {return nil}
            guard let adminArea = administrativeArea else {return nil}
            
            return "\(adminArea) \(locality) \(thoroughtfare) \(subthorughtfare)"
        }
    }
}

extension MKMapView {
    func zoomToFit(annotaitions: [MKAnnotation]) {
        var zommRect = MKMapRect.null
        
        annotaitions.forEach { annotaion in
            let annotationPoint = MKMapPoint(annotaion.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01)
            zommRect = zommRect.union(pointRect)
        }
        //이걸 조정하면 맵뷰 줌되는 정도를 조절할수있다.
        let inset = UIEdgeInsets(top: 100, left: 100, bottom: 300, right: 100)
        setVisibleMapRect(zommRect, edgePadding: inset, animated: true)
    }
    
    func addAnnotationAndSelect(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        addAnnotation(annotation)
        selectAnnotation(annotation, animated: true)
    }
}


extension UIViewController {
    func shouldPresentLoading(_ present: Bool, message: String? = nil) {
        if present {
            let view = UIView()
            view.frame = self.view.frame
            view.backgroundColor = .black
            view.alpha = 0
            view.tag = 1
            
            
            let indicator = UIActivityIndicatorView()
            indicator.style = .large
            indicator.center = view.center
            
            let label = UILabel()
            label.text = message
            label.font = .systemFont(ofSize: 20)
            label.textColor = .white
            label.textAlignment = .center
            label.alpha = 0.87
            
            self.view.addSubview(view)
            view.addSubview(indicator)
            view.addSubview(label)
            
            label.centerX(inView: view)
            label.anchor(top: indicator.bottomAnchor, paddingTop: 32)
            
            indicator.startAnimating()
            UIView.animate(withDuration: 0.3) {
                view.alpha = 0.7
            }
        } else {
            view.subviews.forEach { subview in
                if subview.tag == 1 {
                    UIView.animate(withDuration: 0.3) {
                        subview.alpha = 0
                    } completion: { _ in
                        subview.removeFromSuperview()
                    }

                }
            }
        }
    }
    
    func presentAlertController(title: String ,withMessage: String) {
        let alert = UIAlertController(title: title, message: withMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "네", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
}
