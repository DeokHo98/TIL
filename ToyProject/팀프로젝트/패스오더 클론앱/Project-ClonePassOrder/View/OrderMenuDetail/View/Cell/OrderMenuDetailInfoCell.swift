//
//  OrderMenuDetailInfoCell.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/19.
//

import Foundation
import UIKit
import SnapKit

class OrderMenuDetailInfoCell : UITableViewCell {
    
    static let registerID = "\(OrderMenuDetailInfoCell.self)"
    
    let itemImageView = UIImageView()
    let itemLabelStackView = UIStackView()
    let itemNameLabel = UILabel()
    let itemDesLabel = UILabel()
    let itemPriceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setAttribute()
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setAttribute() {
        itemImageView.contentMode = .scaleToFill
        itemImageView.backgroundColor = .systemGray5
        itemLabelStackView.axis = .vertical
        itemLabelStackView.spacing = 5
        itemLabelStackView.backgroundColor = .none
        itemLabelStackView.alignment = .fill
        itemLabelStackView.distribution = .fillEqually
        itemNameLabel.font = .systemFont(ofSize: 15, weight: .heavy)
        itemDesLabel.font = .systemFont(ofSize: 13, weight: .medium)
        itemDesLabel.textColor = .darkGray
        [itemNameLabel,itemDesLabel].forEach {$0.numberOfLines = 0 }
        itemPriceLabel.font = .systemFont(ofSize: 14, weight: .bold)
        itemNameLabel.text = "test"
        itemDesLabel.text = "설명설명설명설명설명설명설"
        itemPriceLabel.text = "가격"
    }
    
    private func setLayout() {
        [itemImageView,itemLabelStackView].forEach {
            contentView.addSubview($0)
        }
        [itemNameLabel, itemPriceLabel, itemDesLabel].forEach {itemLabelStackView.addArrangedSubview($0)}
        itemImageView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.6)
            $0.height.equalTo(itemImageView.snp.width)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(4)
        }
        itemLabelStackView.snp.makeConstraints {
            $0.top.equalTo(itemImageView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(4)
        }
    }
}

