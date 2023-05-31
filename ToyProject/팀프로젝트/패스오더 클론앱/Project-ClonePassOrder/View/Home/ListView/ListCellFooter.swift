//
//  ListCellFooter.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/19.
//

import UIKit

enum FooterSection {
    case FirstCell
    case SecondCell
    case ThirdCell
}

protocol ListCellDelegate: AnyObject {
    func footerTapped(title: String)
}

class ListCellFooter: UICollectionReusableView {
    
    //MARK: - 식별자
    
    static let identifier = "ListCellFooter"
    
    //MARK: - 프로퍼티
    
    weak var delegate: ListCellDelegate?
    var currentSection: FooterSection = .FirstCell
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "arrow.right")
        iv.tintColor = .lightGray
        iv.alpha = 0.6
        return iv
    }()
    private let moreViewButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("더보기", for: .normal)
        bt.setTitleColor(.black, for: .normal)
        bt.titleLabel?.font = .systemFont(ofSize: 16)
        return bt
    }()
    
    //MARK: - 라이프사이클
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setAtrribute()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 셀렉터메서드
    
    @objc private func moreButtonTapped() {
        switch currentSection {
        case .FirstCell:
            delegate?.footerTapped(title: "가까이 있는 매장")
        case .SecondCell:
            delegate?.footerTapped(title: "스토리가 많은 매장")
        case .ThirdCell:
            delegate?.footerTapped(title: "신규매장")
        }
    }
    
    //MARK: - 메서드
    
    private func setLayout() {
        [imageView,moreViewButton].forEach {
            self.addSubview($0)
        }
        imageView.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(20)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        moreViewButton.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(imageView)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
    }
    private func setAtrribute() {
        moreViewButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
    }
}
