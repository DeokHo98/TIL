//
//  GetTimeView.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/27.
//

import SnapKit
import UIKit

class GetTimeView: UIView {
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "예상 수령시간"
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 15, weight: .semibold)
        return lb
    }()
    let sv0: UIButton = UIButton().timeButton(title: "지금")
    let sv1: UIButton = UIButton().timeButton(title: "+5분")
    let sv2: UIButton = UIButton().timeButton(title: "+10분")
    let sv3: UIButton = UIButton().timeButton(title: "+15분")
    let sv4: UIButton = UIButton().timeButton(title: "+20분")
    let sv5: UIButton = UIButton().timeButton(title: "+30분")
    let sv6: UIButton = UIButton().timeButton(title: "+40분")
    let sv7: UIButton = UIButton().timeButton(title: "+1시간 이상")
    lazy var stackview0 : UIStackView = {
        let sv = UIStackView()
        [sv0,sv1,sv2,sv3].forEach { sv.addArrangedSubview($0) }
        sv.axis = .horizontal
        sv.spacing = 10
        sv.alignment = .fill
        sv.distribution = .fillEqually
        return sv
    }()
    lazy var stackview1 : UIStackView = {
        let sv = UIStackView()
        [sv4,sv5,sv6,sv7].forEach { sv.addArrangedSubview($0) }
        sv.axis = .horizontal
        sv.spacing = 10
        sv.alignment = .fill
        sv.distribution = .fillEqually
        return sv
    }()
    let notiLabel: UILabel = {
        let lb = UILabel()
        lb.text = "* 1시간 이상 시간이 걸리신다면 요청사항에 기입해주세요 "
        lb.textColor = .systemGray3
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
    private func setLayout() {
        [titleLabel, stackview0, stackview1, notiLabel].forEach { self.addSubview($0) }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(12)
        }
        stackview0.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.leadingMargin.equalToSuperview().offset(12)
        }
        stackview1.snp.makeConstraints { make in
            make.top.equalTo(stackview0.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.equalTo(stackview0)
        }
        notiLabel.snp.makeConstraints { make in
            make.top.equalTo(stackview1.snp.bottom).offset(12)
            make.leading.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(15)
        }
    }
}
