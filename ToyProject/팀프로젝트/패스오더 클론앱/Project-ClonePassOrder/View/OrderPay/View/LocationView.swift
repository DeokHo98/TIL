//
//  LocationView.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/25.
//

import Foundation
import SnapKit
import UIKit

class LocationView : UIView {
    let checkView: LeftImgRightLabelView = {
        let cv = LeftImgRightLabelView()
        cv.img.image = UIImage(systemName: "exclamationmark.circle.fill")
        cv.img.tintColor = .orange
        cv.label.text = "주문하시는 매장 위치를 확인해 주세요"
        cv.label.font = .systemFont(ofSize: 15, weight: .semibold)
        cv.backgroundColor = .systemGray5
        return cv
    }()
    let mapView : UIView = {
        let v = UIView()
        v.backgroundColor = .systemGray5
        return v
    }()
    let storeLabel: UILabel = {
        let lb = UILabel()
        lb.text = "매장명"
        lb.font = .systemFont(ofSize: 12, weight: .medium)
        lb.textColor = .black
        return lb
    }()
    let locLabel: UILabel = {
        let lb = UILabel()
        lb.text = "위치위치위치"
        lb.font = .systemFont(ofSize: 11, weight: .regular)
        lb.textColor = .lightGray
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
        [checkView,mapView,storeLabel,locLabel].forEach { self.addSubview($0) }
        checkView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.leadingMargin.equalTo(10)
        }
        mapView.snp.makeConstraints { make in
            make.top.equalTo(checkView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.leadingMargin.equalTo(10)
            make.height.equalTo(mapView.snp.width).multipliedBy(0.3)
        }
        storeLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(5)
            make.leading.equalTo(checkView)
        }
        locLabel.snp.makeConstraints { make in
            make.top.equalTo(storeLabel.snp.bottom).offset(5)
            make.leading.equalTo(checkView)
            make.bottom.equalToSuperview().inset(12)
        }
    }
}
