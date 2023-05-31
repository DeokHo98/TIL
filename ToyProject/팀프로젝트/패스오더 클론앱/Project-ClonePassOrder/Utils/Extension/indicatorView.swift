//
//  indicatorView.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/06/02.
//

import Foundation
import UIKit

extension UIImageView {
    static func indicatorSetLayout(view: UIView,imageView: UIImageView) {
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func indicatorView() -> UIImageView {
        let iv = UIImageView()
        iv.image = UIImage(named: "로딩이미지")
        return iv
    }
}
