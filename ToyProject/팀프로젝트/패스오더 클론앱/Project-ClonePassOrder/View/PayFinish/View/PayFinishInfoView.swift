//
//  PayFinishInfoView.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/27.
//

import SnapKit
import UIKit

class PayFinishInfoView: UIView {
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "주문 정보"
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 15, weight: .semibold)
        return lb
    }()
    let storeName = LeftRightLabel(s: "매장명", c: "빽다방 미사스마트밸리점")
    let orderNum = LeftRightLabel(s: "주문번호", c: "3")
    let menuName = LeftRightLabel(s: "메뉴", c: "앗메리카노")
    let totalPrice = LeftRightLabel(s: "매장명", c: "100원")
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        [storeName,orderNum,menuName,totalPrice].forEach {sv.addArrangedSubview($0)}
        sv.axis = .vertical
        sv.spacing = 5
        sv.alignment = .fill
        sv.distribution = .fillEqually
        return sv
    }()
    let lineView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGray3
        return v
    }()
    let moreBtn: UIButton = {
        let bt = UIButton()
        bt.setTitle("주문 상세 내역 보기 >", for: .normal)
        bt.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        bt.setTitleColor(UIColor.black, for: .normal)
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
        totalPrice.contentLabel.textColor = .orange
    }
    private func setLayout(){
        [titleLabel, stackView,lineView,moreBtn].forEach {self.addSubview($0)}
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(12)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.leadingMargin.equalTo(12)
            make.height.equalTo(1)
        }
        moreBtn.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
    }
}
