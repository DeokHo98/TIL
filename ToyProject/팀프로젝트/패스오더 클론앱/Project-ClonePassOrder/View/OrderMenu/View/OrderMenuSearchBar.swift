//
//  OrderMenuSearchBar.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/17.
//

import Foundation
import UIKit
import SnapKit

class OrderMenuSearchBar : UISearchBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttribute()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setAttribute() {
        self.placeholder = "먹고 싶은 메뉴를 검색해 보세요"
        self.searchBarStyle = .minimal
    }
}
