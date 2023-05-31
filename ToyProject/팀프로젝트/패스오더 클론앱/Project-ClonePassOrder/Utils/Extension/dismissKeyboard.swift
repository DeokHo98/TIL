//
//  UIViewController.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/27.
//

import UIKit

extension UIViewController {
    func dismissKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
}
