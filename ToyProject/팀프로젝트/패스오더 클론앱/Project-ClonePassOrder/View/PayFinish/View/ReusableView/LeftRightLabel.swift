//
//  LeftRightLabel.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/27.
//

import SnapKit
import UIKit

class LeftRightLabel: UIView {
    var titleStr : String?
    var contentStr : String?
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .lightGray
        lb.font = .systemFont(ofSize: 13, weight: .regular)
        return lb
    }()
    let contentLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 13, weight: .regular)
        return lb
    }()
    init(s: String, c: String) {
        self.titleStr = s
        self.contentStr = c
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
        contentLabel.text = contentStr
    }
    private func setLayout(){
        [titleLabel,contentLabel].forEach {self.addSubview($0)}
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.topMargin.equalTo(4)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(12)
        }
    }
}

