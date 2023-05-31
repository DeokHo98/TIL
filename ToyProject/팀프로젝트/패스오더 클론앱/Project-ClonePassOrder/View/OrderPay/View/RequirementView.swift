//
//  RequirementView.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/27.
//

import SnapKit
import UIKit

class RequirementView: UIView {
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "요청 사항"
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 15, weight: .semibold)
        return lb
    }()
    let requirementTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "요청 사항을 입력해주세요"
        tf.font = .systemFont(ofSize: 13, weight: .regular)
        tf.textColor = .black
        tf.clearButtonMode = .always
        return tf
    }()
    let tfBottomLine: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGray3
        return v
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
        [titleLabel,requirementTF,tfBottomLine].forEach {self.addSubview($0)}
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(12)
        }
        requirementTF.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.leadingMargin.equalTo(12)
        }
        tfBottomLine.snp.makeConstraints { make in
            make.top.equalTo(requirementTF.snp.bottom).offset(1.5)
            make.leading.trailing.equalTo(requirementTF)
            make.height.equalTo(1)
            make.bottom.equalToSuperview().inset(15)
        }
    }
}
