//
//  CommentsCell.swift
//  Instargram-Clone
//
//  Created by 정덕호 on 2022/04/06.
//

import Foundation
import UIKit


class CommentsCell: UICollectionViewCell {
    static let identified = "CommentsCell"
    
    //MARK: - 속성
    
    var viewModel: CommentsViewModel? {
        didSet {
            configure()
        }
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let commentLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - 라이프사이클
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self,leftAnchor: leftAnchor,paddingLeft: 8)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(commentLabel)
        commentLabel.centerY(inView: profileImageView,leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        
        commentLabel.anchor(right: rightAnchor, paddingRight:  8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 도움메서드
    
    func configure() {
        guard let viewModel = viewModel else {
            return
        }
        
        profileImageView.sd_setImage(with: viewModel.userProfileImageUrl)
        commentLabel.attributedText = viewModel.commentLabelText()
        
    }
}
