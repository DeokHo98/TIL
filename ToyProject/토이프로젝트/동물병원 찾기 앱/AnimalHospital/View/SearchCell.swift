//
//  SearchCell.swift
//  AnimalHospital
//
//  Created by 정덕호 on 2022/04/14.
//

import Foundation

import UIKit

class SearchCell: UITableViewCell {
    static let identifier = "searchcell"
    
    //MARK: - 속성
    let namelabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let adressLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [namelabel, adressLabel])
        stack.axis = .vertical
        stack.spacing = 0
        return stack
    }()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        addSubview(stack)
        stack.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor,paddingTop: 10,paddingLeading: 20,paddingBottom: 10,paddingTrailing: 20)
    }
    
    
}
