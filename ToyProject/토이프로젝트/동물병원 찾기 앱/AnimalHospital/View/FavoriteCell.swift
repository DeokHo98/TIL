//
//  FavoriteCell.swift
//  AnimalHospital
//
//  Created by 정덕호 on 2022/04/19.
//

import UIKit

class FavoriteCell: UITableViewCell {
    static let identifier = "favoritecell"
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "동두천시 노상 공영주차장"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "경기 동두천시 동두천동 245-156"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    lazy var image: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "star.fill")
        iv.tintColor = .systemYellow
        iv.setWidth(25)
        iv.setHeight(25)
        return iv
    }()
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundColor = .white
        
        addSubview(nameLabel)
        nameLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor,trailing: self.trailingAnchor, paddingTop: 20, paddingLeading: 20, paddingTrailing: 20)
        
        addSubview(addressLabel)
        addressLabel.anchor(top: nameLabel.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, paddingTop: 10, paddingLeading: 20,paddingTrailing: 20)
        
        addSubview(image)
        image.centerY(inView: self)
        image.anchor(trailing: self.trailingAnchor, paddingTrailing: 20)
      
    }
}
