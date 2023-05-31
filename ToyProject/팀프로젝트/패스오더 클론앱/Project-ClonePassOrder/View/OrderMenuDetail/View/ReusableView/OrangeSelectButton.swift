//
//  OrangeSelectButton.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/23.
//

import SnapKit
import UIKit

class OrangeSelectButton : UIView {
    let getButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("담기", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.backgroundColor = .systemOrange
        bt.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        bt.layer.cornerRadius = 8
        return bt
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttribute()
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setAttribute(){
        self.backgroundColor = .white
    }
    private func setLayout(){
        self.addSubview(getButton)
        getButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leadingMargin.equalTo(8)
            make.top.equalToSuperview().offset(4)
            make.height.equalToSuperview().multipliedBy(0.58)
        }
    }
}
