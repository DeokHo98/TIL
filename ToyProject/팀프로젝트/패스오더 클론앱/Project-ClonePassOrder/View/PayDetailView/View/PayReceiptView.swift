//
//  PayReceiptView.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/27.
//

import SnapKit
import UIKit

class PayReceiptView: UIView {
    let lineView: UIView = {
        let v = UIView()
        v.backgroundColor = .gray
        return v
    }()
    let topicLabel = ThreeLabelView(str1: "메뉴명", str2: "수량", str3: "금액", color: .orange, strSize: 13)
    let itemlabel = ThreeLabelView(str1: "앗메리카노", str2: "1", str3: "100원", color: .black, strSize: 15)
    let itemlabe2 = ThreeLabelView(str1: "앗메리카노", str2: "1", str3: "100원", color: .black, strSize: 15)
    let itemlabe3 = ThreeLabelView(str1: "앗메리카노", str2: "1", str3: "100원", color: .black, strSize: 15)
    lazy var itemStackView: UIStackView = {
        let sv = UIStackView()
        [topicLabel,itemlabel,itemlabe2,itemlabe3].forEach {sv.addArrangedSubview($0)}
        sv.axis = .vertical
        sv.spacing = 2
        sv.alignment = .fill
        sv.distribution = .fill
        sv.backgroundColor = .white
        return sv
    }()
    let getLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .systemGray3
        lb.font = .systemFont(ofSize: 13, weight: .regular)
        lb.text = "10분 뒤에 받으러 갈게요"
        return lb
    }()
    let lineView2: UIView = {
        let v = UIView()
        v.backgroundColor = .gray
        return v
    }()
    let totalLabel = LeftRightLabel(s: "합계", c: "100원")
    let payTotalLabel = LeftRightLabel(s: "결제금액", c: "100원")
    let lineView3: UIView = {
        let v = UIView()
        v.backgroundColor = .gray
        return v
    }()
    let helpLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 13, weight: .regular)
        lb.text = "결제 취소 관련 문의는 해당 매장에 연락해 주시기 바랍니다."
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
        [totalLabel.titleLabel,totalLabel.contentLabel].forEach {$0.font = .systemFont(ofSize: 15, weight: .medium)}
        [payTotalLabel.titleLabel, payTotalLabel.contentLabel].forEach {
            $0.textColor = .orange
            $0.font = .systemFont(ofSize: 18, weight: .medium)
        }
    }
    private func setLayout(){
        [lineView,itemStackView,getLabel,lineView2,totalLabel,payTotalLabel,lineView3,helpLabel].forEach{self.addSubview($0)}
        lineView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.leadingMargin.equalTo(12)
            make.height.equalTo(1)
        }
        itemStackView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview()
        }
        getLabel.snp.makeConstraints { make in
            make.top.equalTo(itemStackView.snp.bottom).offset(20)
            make.leading.equalTo(lineView)
        }
        lineView2.snp.makeConstraints { make in
            make.top.equalTo(getLabel.snp.bottom).offset(15)
            make.leading.trailing.equalTo(lineView)
            make.height.equalTo(lineView)
        }
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView2.snp.bottom).offset(15)
            make.leading.trailing.equalTo(itemStackView)
        }
        payTotalLabel.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(15)
            make.leading.trailing.equalTo(itemStackView)
        }
        lineView3.snp.makeConstraints { make in
            make.top.equalTo(payTotalLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(lineView)
            make.height.equalTo(lineView)
        }
        helpLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView3.snp.bottom).offset(20)
            make.leading.equalTo(lineView)
        }
        
    }
}
