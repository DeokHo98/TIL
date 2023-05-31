//
//  LastListCell.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/20.
//

import UIKit

class FourthListCell: UICollectionViewCell {
    //MARK: - 식별자
    
    static let identifier = "LastListCell"
    
    //MARK: - 프로퍼티
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "리스트로보기이미지")
        return iv
    }()
    private let backView: UIView = {
       let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .boldSystemFont(ofSize: 28)
        lb.text = "패스오더"
        return lb
    }()
    private let infoLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .lightGray
        lb.numberOfLines = 0
        lb.font = .systemFont(ofSize: 14)
        lb.text = "패스오더는 통신판매중개자이며, 통신판매의 당사자가 아닙니다. 따라서 패스오더는 상품거래 정보 및 거래에 대한 책임을 지지 않습니다."
        return lb
    }()
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
        [separatorView,imageView,backView].forEach {
            self.addSubview($0)
        }
        [titleLabel,infoLabel].forEach {
            backView.addSubview($0)
        }
        separatorView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom)
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview()
            make.height.equalTo(220)
        }
        backView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.top).offset(20)
            make.leading.equalTo(backView.snp.leading).offset(20)
        }
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(backView.snp.leading).offset(20)
            make.trailing.equalTo(backView.snp.trailing)
        }
    }
}
