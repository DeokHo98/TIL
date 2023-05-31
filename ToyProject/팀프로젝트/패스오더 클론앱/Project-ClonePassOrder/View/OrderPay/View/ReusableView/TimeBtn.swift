//
//  TimeBtn.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/27.
//

import SnapKit
import UIKit

extension UIButton {
    func timeButton(title: String, color: UIColor = .systemGray4, size: CGFloat = 12) -> UIButton {
        let bt = UIButton(type: .system)
        bt.setTitle(title, for: .normal)
        bt.setTitleColor(color, for: .normal)
        bt.layer.borderColor = color.cgColor
        bt.layer.cornerRadius = 8
        bt.layer.borderWidth = 1.0
        bt.titleLabel?.font = .systemFont(ofSize: size)
        return bt
    }
}
