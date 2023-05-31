//
//  MenuCollectionView.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/17.
//

import Foundation
import UIKit
import SnapKit

class MenuCollectionView : UICollectionView {
    
    let flowLayout = UICollectionViewFlowLayout()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        
        setAttribute()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MenuCollectionView {
    private func setAttribute() {
        self.backgroundColor = .white
        self.showsHorizontalScrollIndicator = false
        self.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: MenuCollectionViewCell.registerID)
        self.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 7
    }
    func setBind(_ viewModel : MenuCollectionViewModel) {
        viewModel.categoryArr.bind { [weak self] _ in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
}
    
