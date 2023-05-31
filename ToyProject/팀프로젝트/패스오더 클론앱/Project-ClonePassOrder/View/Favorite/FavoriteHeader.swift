//
//  FavoriteHeader.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/20.
//

import UIKit

class FavoriteHeader: UICollectionReusableView {
    
    //MARK: - 식별자
    
    static let identifier = "FavoriteHeader"
        
    //MARK: - 프로퍼티
    private let label: UILabel = {
        let lb = UILabel()
        lb.text = "패써님이 자주가는 매장이에요!"
        lb.textColor = .black
        lb.font = .boldSystemFont(ofSize: 18)
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
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-30)
        }
    }
}
