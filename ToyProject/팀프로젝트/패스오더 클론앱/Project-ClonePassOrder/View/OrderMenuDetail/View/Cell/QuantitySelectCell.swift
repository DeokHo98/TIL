//
//  QuantitySelectCell.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/19.
//

import Foundation
import SnapKit
import UIKit

protocol QuantitySelectCellDelegate : AnyObject {
    func quantityBtnTapped(_ sender : UIButton, _ at : UILabel)
}

class QuantitySelectCell : UITableViewCell {
    
    static let registerID = "\(QuantitySelectCell.self)"
    
    let containView = UIView()
    let quantityLabel: UILabel = {
        let lb = UILabel()
        lb.text = "수량"
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 13, weight: .medium)
        return lb
    }()
    let quantityView = QuantitySelectView()
    var delegate : QuantitySelectCellDelegate?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setAttribute()
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setAttribute(){
        contentView.isUserInteractionEnabled = true
        containView.backgroundColor = .systemGray5
        containView.layer.cornerRadius = 8
        [quantityView.minusButton, quantityView.plusButton].forEach {$0.addTarget(self, action: #selector(quantityBtnTapped(_:_:)), for: .touchUpInside)}
    }
    private func setLayout(){
        self.addSubview(containView)
        [quantityView,quantityLabel].forEach { containView.addSubview($0)}
        containView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(3)
            make.trailing.equalToSuperview().inset(3)
            make.height.equalTo(quantityView.getLabelHeight(quantityView.quantityLabel) + 10)
            make.center.equalToSuperview()
        }
        quantityLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        quantityView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(containView).inset(5)
            //make.height.equalTo(containView)
        }
    }
    @objc func quantityBtnTapped(_ sender : UIButton, _ at : UILabel) {
        delegate?.quantityBtnTapped(sender,quantityView.quantityLabel)
    }
}
