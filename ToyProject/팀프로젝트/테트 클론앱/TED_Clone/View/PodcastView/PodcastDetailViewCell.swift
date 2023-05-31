//
//  PodcastDetailViewCell.swift
//  TED_Clone
//
//  Created by 정덕호 on 2022/03/14.
//

import UIKit
//MARK: - 커스텀 셀

class PodcastDetailViewCell: UITableViewCell {
    static let identifier = "DetailCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        cellSetting()
    }

        

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
     let cellImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "arrowtriangle.right.fill")
        image.tintColor = .white
        return image
    }()
    
     let nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
     let timeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    
    func cellSetting() {
       addSubview(cellImage)
        cellImage.anchor(left: self.leadingAnchor,paddingLeft: 10,width: 20, height: 25)
        cellImage.centerY(inView: self)
    
        addSubview(nameLabel)
        nameLabel.anchor(left: cellImage.trailingAnchor,bottom: cellImage.topAnchor,right: self.trailingAnchor,paddingLeft: 20,paddingBottom: -10,paddingRight: 10)
        
        addSubview(timeLabel)
        timeLabel.anchor(top: cellImage.bottomAnchor,left: cellImage.trailingAnchor, paddingTop: -10,paddingLeft: 20)
    }
    
}
