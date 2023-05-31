//
//  SVProgressHUD.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/31.
//

import Foundation
import SVProgressHUD


extension SVProgressHUD {
    static func SVshow(view: UIView, text: String, button: [UIButton]) {
        SVProgressHUD.show(withStatus: text)
        view.alpha = 0.2
        button.forEach {
            $0.isEnabled = false
        }
    }
   static func SVoff(view: UIView,button: [UIButton]) {
        SVProgressHUD.dismiss()
        view.alpha = 1
       button.forEach {
           $0.isEnabled = true
       }
    }
}
