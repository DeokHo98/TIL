//
//  AfterPayInfoLabel.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/27.
//

import SnapKit
import UIKit

class AfterPayInfoLabel: UIView {
    var titleStr : String?
    var subStr1 : String?
    var subStr2 : String?
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 13, weight: .semibold)
        return lb
    }()
    let contentLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 13, weight: .light)
        return lb
    }()
    let lineLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .systemGray3
        lb.text = "|"
        lb.font = .systemFont(ofSize: 13, weight: .light)
        return lb
    }()
    let contentLabel2: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 13, weight: .light)
        return lb
    }()
    init(titleStr : String, subStr1: String, subStr2: String) {
        self.titleStr = titleStr
        self.subStr1 = subStr1
        self.subStr2 = subStr2
        super.init(frame:  CGRect(x: 0, y: 0, width: 0, height: 0))
        setAttribute()
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setAttribute(){
        self.backgroundColor = .white
        titleLabel.text = titleStr
        contentLabel.text = subStr1
        contentLabel2.text = subStr2
    }
    private func setLayout(){
        [titleLabel, contentLabel, lineLabel, contentLabel2].forEach { self.addSubview($0)}
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.topMargin.equalTo(3)
        }
        contentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.leading.equalTo(titleLabel.snp.trailing).offset(4)
        }
        lineLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.leading.equalTo(contentLabel.snp.trailing).offset(8)
        }
        contentLabel2.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.leading.equalTo(lineLabel.snp.trailing).offset(8)
        }
    }
}
