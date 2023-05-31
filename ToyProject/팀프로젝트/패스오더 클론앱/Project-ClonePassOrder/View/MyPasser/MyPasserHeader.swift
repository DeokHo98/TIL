//
//  MyPasserHeader.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/21.
//

import UIKit
import Kingfisher

class MyPasserHeader: UITableViewHeaderFooterView {
    
    //MARK: - 식별자
    
    static let identifier: String = "MyPasserHeader"
    
    //MARK: - 프로퍼티
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 45 / 2
        return iv
    }()
    private let label: UILabel = {
        let lb = UILabel()
        lb.text = "정덕호"
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 20)
        return lb
    }()
    
    //MARK: - 라이프사이클
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setLayout()
        setAtrribute()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 메서드
    
    private func setLayout() {
        [imageView,label].forEach {
            self.addSubview($0)
        }
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.height.width.equalTo(45)
            make.centerY.equalToSuperview().offset(-10)
        }
        label.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(20)
            make.centerY.equalTo(imageView)
        }
    }
    private func setAtrribute() {
        label.text = UserViewModel.shared.userName
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: UserViewModel.shared.profileImageUrl)

    }
}
