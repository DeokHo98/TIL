//
//  ListCellHeader.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/19.
//

import UIKit

class ListCellHeader: UICollectionReusableView {
    
    //MARK: - 식별자
    
    static let identifier = "ListCellHeader"
    
    //MARK: - 프로퍼티
    let firstLabel: UILabel = UILabel().listLabel(
        text: "",
        color: .black,
        font: .boldSystemFont(ofSize: 22)
    )
    let secondLabel: UILabel = UILabel().listLabel(
        text: "",
        color: .black,
        font: .boldSystemFont(ofSize: 28)
    )
    
    //MARK: - 라이프사이클
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 메서드
    
    private func setLayout() {
        [firstLabel,secondLabel].forEach {
            self.addSubview($0)
        }
        firstLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview()
        }
        secondLabel.snp.makeConstraints { make in
            make.top.equalTo(firstLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview()
        }
    }
}
