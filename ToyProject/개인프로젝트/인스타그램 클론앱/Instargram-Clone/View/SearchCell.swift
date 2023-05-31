//
//  TableViewCell.swift
//  Instargram-Clone
//
//  Created by 정덕호 on 2022/04/05.
//

import UIKit

class SearchCell: UITableViewCell {
    static let identifier = "searchcell"
    
    //MARK: - 속성
    
    var user: SearchViewModel? {
        didSet {
            configura()
        }
    }
    
    private let profileImageView: UIImageView = {
       let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.backgroundColor = .lightGray
        view.image = #imageLiteral(resourceName: "venom-7")
        return view
    }()
    
    private let usernameLabel: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.text = "베놈"
        return label
    }()
    
    private let FullnameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = "에디브록"
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [usernameLabel, FullnameLabel])
        view.axis = .vertical
        view.spacing = 4
        view.alignment = .leading
        
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        addSubview(profileImageView)
        profileImageView.setDimensions(height: 48, width: 48)
        profileImageView.layer.cornerRadius = 48 / 2
        profileImageView.centerY(inView: self,leftAnchor: leftAnchor,paddingLeft: 12)
        
        
        addSubview(stackView)
        stackView.centerY(inView: profileImageView,leftAnchor: profileImageView.rightAnchor,paddingLeft: 8)
    }
    
    //MARK: - 도움메서드
    func configura() {
        usernameLabel.text = user?.userName
        FullnameLabel.text = user?.fullname
        profileImageView.sd_setImage(with: user?.profileImageURL, completed: nil)
    }

}
