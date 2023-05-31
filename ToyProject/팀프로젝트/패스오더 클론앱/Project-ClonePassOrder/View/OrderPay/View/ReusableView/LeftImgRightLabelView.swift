//
//  LeftImgRightLabelView.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/26.
//

import SnapKit
import UIKit

class LeftImgRightLabelView: UIView {
    let img: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    let label: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
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
        self.layer.cornerRadius = 8
    }
    private func setLayout(){
        [img,label].forEach {self.addSubview($0)}
        img.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
        }
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(img.snp.trailing).offset(10)
            make.topMargin.equalTo(4)
        }
    }
}
