//
//  PayDetailInfoView.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/27.
//

import SnapKit
import UIKit

class PayDetailInfoView: UIView {
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "빽다방 방이시장점\n주문 상세내역"
        lb.numberOfLines = 0
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 30, weight: .heavy)
        return lb
    }()
    let orderInfo1 = AfterPayInfoLabel(titleStr: "주문번호 : ", subStr1: "3", subStr2: "가져갈게요")
    let orderInfo2 = AfterPayInfoLabel(titleStr: "결제정보 : ", subStr1: "신한카드 결제", subStr2: "2022.05.05 13:18")
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
        [titleLabel,orderInfo1,orderInfo2].forEach {self.addSubview($0)}
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(12)
        }
        orderInfo1.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel)
        }
        orderInfo2.snp.makeConstraints { make in
            make.top.equalTo(orderInfo1.snp.bottom)
            make.leading.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(15)
        }
    }
}
