//
//  DetailMenuTableView.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/17.
//

import Foundation
import UIKit
import SnapKit

class DetailMenuTableView : UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .plain)
        
        setTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTableView() {
        self.backgroundColor = .white
        self.register(DetailMenuTableViewCell.self, forCellReuseIdentifier: DetailMenuTableViewCell.registerID)
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = ScreenConstant.deviceHeight * 0.2
        self.separatorStyle = .singleLine
        if #available(iOS 15.0, *) {
          self.sectionHeaderTopPadding = 0
        }
        self.bounces = false
    }
    func setBind(_ viewModel : DetailMenuTableViewModel) {
        viewModel.menuArr.bind { [weak self] _ in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
}
