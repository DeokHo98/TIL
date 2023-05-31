//
//  OrderMenuDetailTableView.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/19.
//

import Foundation
import UIKit
import SnapKit

class OrderMenuDetailTableView : UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .grouped)
        
        setTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTableView() {
        self.backgroundColor = .white
        self.rowHeight = UITableView.automaticDimension
        self.separatorStyle = .none
        if #available(iOS 15.0, *) {
          self.sectionHeaderTopPadding = 0
        }
        self.register(OrderMenuDetailInfoCell.self, forCellReuseIdentifier: OrderMenuDetailInfoCell.registerID)
        self.register(QuantitySelectCell.self, forCellReuseIdentifier: QuantitySelectCell.registerID)
        self.register(IceSelectCell.self, forCellReuseIdentifier: IceSelectCell.registerID)
    }
}
