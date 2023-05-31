//
//  TotalOrderView.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/27.
//

import SnapKit
import UIKit

class TotalOrderView: UIView {
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "총 주문 금액"
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 15, weight: .semibold)
        return lb
    }()
    let payLabel: UILabel = {
        let lb = UILabel()
        lb.text = "최종 결제 금액"
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 13, weight: .medium)
        return lb
    }()
    let wonLabel: UILabel = {
        let lb = UILabel()
        lb.text = "3,500원"
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 15, weight: .bold)
        return lb
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
        [titleLabel,payLabel,wonLabel].forEach {self.addSubview($0) }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(12)
        }
        payLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(titleLabel)
        }
        wonLabel.snp.makeConstraints { make in
            make.top.equalTo(payLabel)
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(15)
        }
    }
}
