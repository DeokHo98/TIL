//
//  PayInfoView.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/27.
//

import SnapKit
import UIKit

class PayInfoView: UIView {
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "주문 상품정보"
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 15, weight: .semibold)
        return lb
    }()
    let payInfoView = PayItemInfoView()
    let payInfoView2 = PayItemInfoView()
    lazy var itemStackView: UIStackView = {
        let sv = UIStackView()
        [payInfoView,payInfoView2].forEach { sv.addArrangedSubview($0) }
        sv.axis = .vertical
        sv.spacing = 0
        sv.alignment = .fill
        sv.distribution = .fillEqually
        return sv
    }()
    let moreBtn: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(systemName: "plus.app"), for: .normal)
        bt.setTitle(" 메뉴 더 담기", for: .normal)
        bt.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        bt.setTitleColor(UIColor.black, for: .normal)
        bt.tintColor = .black
        bt.semanticContentAttribute = .forceLeftToRight
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
        [titleLabel,itemStackView,moreBtn].forEach { self.addSubview($0) }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(10)
        }
        itemStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
        }
        moreBtn.snp.makeConstraints { make in
            make.top.equalTo(itemStackView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
    }
}
