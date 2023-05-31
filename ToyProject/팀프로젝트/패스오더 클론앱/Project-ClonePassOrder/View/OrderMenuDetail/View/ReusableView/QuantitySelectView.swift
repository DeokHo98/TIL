//
//  QuantitySelectView.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/22.
//

import SnapKit
import UIKit

class QuantitySelectView : UIView {
    let minusButton: UIButton = {
        let bt = UIButton()
        bt.tintColor = .black
        bt.setImage(UIImage(systemName: "minus.circle"), for: .normal)
        bt.tag  = 0
        return bt
    }()
     var quantityLabel: UILabel = {
        let lb = UILabel()
        lb.text = "1"
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 15)
        lb.textAlignment = .center
        return lb
    }()
    let plusButton: UIButton = {
        let bt = UIButton()
        bt.tintColor = .black
        bt.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        bt.tag = 1
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
        self.backgroundColor = .none
    }
    private func setLayout(){
        [minusButton,quantityLabel,plusButton].forEach { self.addSubview($0)
        }
        minusButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(3)
            make.centerY.equalToSuperview()
            make.topMargin.equalTo(5)
            make.height.width.equalTo(getLabelHeight(quantityLabel))
        }
        quantityLabel.snp.makeConstraints { make in
            make.leading.equalTo(minusButton.snp.trailing).offset(7)
            make.centerY.equalTo(minusButton)
        }
        plusButton.snp.makeConstraints { make in
            make.leading.equalTo(quantityLabel.snp.trailing).offset(7)
            make.centerY.equalTo(minusButton)
            make.trailing.equalToSuperview().inset(3)
            make.height.width.equalTo(minusButton)
        }
    }
}
