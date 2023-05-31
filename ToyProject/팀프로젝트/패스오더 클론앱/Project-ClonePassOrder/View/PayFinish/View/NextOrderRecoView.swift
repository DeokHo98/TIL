//
//  NextOrderRecoView.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/27.
//

import SnapKit
import UIKit

class NextOrderRecoView: UIView {
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "다음 주문 시\n이 매장은 어때요? 🔍"
        lb.textColor = .black
        lb.numberOfLines = 0
        lb.font = .systemFont(ofSize: 15, weight: .semibold)
        return lb
    }()
    let recoCV: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGray3
        return v
    }()
    let questionlabel: UILabel = {
        let lb = UILabel()
        lb.text = "다양한 정보를 확인하셨나요?"
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 13, weight: .regular)
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
        [titleLabel,recoCV,questionlabel].forEach {self.addSubview($0)}
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(12)
        }
        recoCV.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        questionlabel.snp.makeConstraints { make in
            make.top.equalTo(recoCV.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
