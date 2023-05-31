//
//  MenuCollectionViewCell.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/17.
//

import Foundation
import UIKit
import SnapKit

class MenuCollectionViewCell : UICollectionViewCell {
    
    static let registerID = "\(MenuCollectionViewCell.self)"
    
    let categoryLabel = UILabel()
    
    let cellViewModel = MenuCollectionCellViewModel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.categoryLabel.textColor = .black
            } else {
                self.categoryLabel.textColor = .lightGray
            }
        }
    }
    
}

extension MenuCollectionViewCell {
    private func setAttribute() {
        self.addSubview(categoryLabel)
        categoryLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        categoryLabel.textColor = .lightGray
        
    }
    private func setLayout() {
        categoryLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    func setData(_ model : CategoryModel) {
        let _model = cellViewModel.changeDataFormat(model)
        categoryLabel.text = _model.categoryName
    }
}
