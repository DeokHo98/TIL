//
//  PayStateView.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/27.
//

import SnapKit
import UIKit

class PayStateView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttribute()
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setAttribute(){
        self.backgroundColor = .gray
    }
    private func setLayout(){
        self.snp.makeConstraints { make in
            make.height.equalTo(150)
        }
    }
}
