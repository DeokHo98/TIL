//
//  File.swift
//  Project-Clone-Uber
//
//  Created by 정덕호 on 2022/03/25.
//

import UIKit

class MenuHeader: UIView {
    
    
    
    //MARK: - 속성
    
 
    
     let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        return iv
    }()
    
     let  fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.text = "정덕호"
        label.textColor = .white
        return label
    }()
    
     let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "test@gamil.com"
        return label
    }()
    
    //MARK: - 라이프사킬
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor,leading: leadingAnchor, paddingTop: 50, paddingLeading: 12,width: 64,height: 64)
        profileImageView.layer.cornerRadius = 64 / 2
        
        let stact = UIStackView(arrangedSubviews: [fullNameLabel,emailLabel])
        stact.distribution = .fillEqually
        stact.spacing = 4
        stact.axis = .vertical
        
        addSubview(stact)
        stact.centerY(inView: profileImageView, leftAnchor: profileImageView.trailingAnchor, paddingLeft: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 셀렉터
    
}
