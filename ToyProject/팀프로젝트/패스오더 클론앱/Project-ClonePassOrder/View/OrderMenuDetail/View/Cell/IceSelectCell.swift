//
//  IceSelectCell.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/24.
//

import Foundation
import SnapKit
import UIKit

protocol OptionCellDelegate : AnyObject {
    func optionTapped(_ sender : UIButton)
}

class IceSelectCell : UITableViewCell {
    
    static let registerID = "\(IceSelectCell.self)"
    
    let optionLabel: UILabel = {
        let lb = UILabel()
        lb.text = "각얼음(추천)"
        lb.textColor = .lightGray
        lb.font = .systemFont(ofSize: 12, weight: .medium)
        return lb
    }()
    let moneyCircleBtn = MoneyCircleButton()
    var delegate : OptionCellDelegate?
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
        moneyCircleBtn.addTarget(self, action: #selector(moneyCircleBtnTapped(_:)), for: .touchUpInside)
    }
    private func setLayout(){
        [optionLabel,moneyCircleBtn].forEach {self.addSubview($0)}
        optionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        moneyCircleBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
    }
    @objc func moneyCircleBtnTapped(_ sender: UIButton) {
        delegate?.optionTapped(sender)
    }
}
