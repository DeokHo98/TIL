//
//  PayItemInfoView.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/26.
//

import SnapKit
import UIKit

class PayItemInfoView : UIView {
    let itemNameLabel: UILabel = {
       let lb = UILabel()
        lb.text = "메뉴"
        lb.font = .systemFont(ofSize: 13, weight: .medium)
        lb.textColor = .black
        return lb
    }()
    let itemDesLabel: UILabel = {
       let lb = UILabel()
        lb.text = "설명"
        lb.font = .systemFont(ofSize: 12, weight: .regular)
        lb.textColor = .lightGray
        return lb
    }()
    lazy var itemStackView: UIStackView = {
        let sv = UIStackView()
        [itemNameLabel, itemDesLabel].forEach {sv.addArrangedSubview($0)}
        sv.axis = .vertical
        sv.spacing = 8
        sv.alignment = .fill
        sv.distribution = .fillEqually
        return sv
    }()
    let priceLabel: UILabel = {
       let lb = UILabel()
        lb.text = "가격"
        lb.font = .systemFont(ofSize: 13, weight: .bold)
        lb.textColor = .black
        return lb
    }()
    let lineView: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    let quantityView = QuantitySelectView()
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
        [itemStackView,priceLabel,quantityView,lineView].forEach { self.addSubview($0) }
        itemStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().inset(10)
        }
        quantityView.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(5)
            make.trailing.equalTo(priceLabel)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(quantityView.snp.bottom).offset(8)
            make.trailing.equalTo(priceLabel)
            make.leading.equalTo(itemStackView)
            make.height.equalTo(1)
            make.bottom.equalToSuperview().inset(8)
        }
    }
}
