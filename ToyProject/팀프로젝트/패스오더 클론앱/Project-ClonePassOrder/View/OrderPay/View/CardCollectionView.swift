//
//  CardCollectionView.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/27.
//

import SnapKit
import UIKit

class CardCollectionView : UICollectionView {
    let flowLayout = UICollectionViewFlowLayout()
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        setAttribute()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setAttribute(){
        self.backgroundColor = .white
        self.showsHorizontalScrollIndicator = false
        self.contentInsetAdjustmentBehavior = .always
        flowLayout.scrollDirection = .horizontal
        self.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: CardCollectionViewCell.registerID)
    }
}
