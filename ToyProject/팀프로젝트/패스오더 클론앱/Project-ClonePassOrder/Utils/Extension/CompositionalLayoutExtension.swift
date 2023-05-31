//
//  SortExtension.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/20.
//

import UIKit

extension NSCollectionLayoutSection {
    static func sortLayout(
        supplementaryItem: NSCollectionLayoutBoundarySupplementaryItem? = nil
    ) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .absolute(250))
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top:0, leading: 10, bottom: 0, trailing: 0
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .fractionalHeight(1/2.7)),
            subitem: item, count: 2
        )
        group.contentInsets = NSDirectionalEdgeInsets(
            top:0, leading: 0, bottom: 0, trailing: 10
        )
        let section = NSCollectionLayoutSection(group: group)
        if let item = supplementaryItem {
            section.boundarySupplementaryItems = [item]
            return section
        } else {
            return section
        }
    }
}
