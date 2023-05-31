//
//  CardView.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/27.
//

import SnapKit
import UIKit

class CardView: UIView {
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "결제 수단"
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 15, weight: .semibold)
        return lb
    }()
    let cardCV = CardCollectionView()
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
        [titleLabel,cardCV].forEach {self.addSubview($0)}
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(12)
        }
        cardCV.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.width.equalToSuperview()
            make.height.equalTo(ScreenConstant.deviceWidth * 0.45 * 0.7)
            make.bottom.equalToSuperview().inset(15)
        }
    }
}
