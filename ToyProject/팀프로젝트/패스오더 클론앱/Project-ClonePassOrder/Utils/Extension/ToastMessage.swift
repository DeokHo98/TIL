//
//  ToastMessage.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/30.
//

import Foundation
import UIKit

struct Toast {
    static func message(superView: UIView, text: String) {
        let label = UILabel()
        if Toast.toastBool {
            Toast.toastBool = false
            label.text = text
            label.font = .systemFont(ofSize: 16)
            label.backgroundColor = .darkGray
            label.alpha = 0.8
            label.textColor = .white
            label.clipsToBounds = true
            label.layer.cornerRadius = 35 / 2
            label.textAlignment = .center
            label.sizeToFit()
            let width = label.bounds.size.width
            superView.addSubview(label)
            label.snp.makeConstraints { make in
                make.height.equalTo(35)
                make.width.equalTo(width + 30)
                make.centerX.equalToSuperview()
                make.bottom.equalTo(superView.snp.bottomMargin).offset(-50)
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                label.removeFromSuperview()
                    Toast.toastBool = true
            }
        }
        
    }
    static var toastBool: Bool = true
}
