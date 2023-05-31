//
//  MoneyCircleButton.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/24.
//

import SnapKit
import UIKit

class MoneyCircleButton : UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttribute()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setAttribute(){
        self.setTitle("0원  ", for: .normal)
        self.setTitleColor(.lightGray, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        self.setImage(UIImage(systemName: "circle"), for: .normal)
        self.tintColor = .lightGray
        self.semanticContentAttribute = .forceRightToLeft
    }
}
