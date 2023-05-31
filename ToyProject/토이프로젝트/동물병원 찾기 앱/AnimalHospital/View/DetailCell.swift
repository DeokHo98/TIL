//
//  DetailCell.swift
//  AnimalHospital
//
//  Created by 정덕호 on 2022/04/15.
//

import UIKit

class DetailCell: UITableViewCell {
    static let identifier = "detailcell"
    
    //MARK: - 속성
    
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    let cellLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cellLabel,detailLabel])
        stack.axis = .horizontal
        stack.spacing = 25
        return stack
    }()
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundColor = .white
        
        addSubview(stack)
        stack.anchor(leading: self.leadingAnchor, trailing: self.trailingAnchor,paddingLeading: 20,paddingTrailing: 20)
        stack.centerY(inView: self)
        
        
    }
    
}
