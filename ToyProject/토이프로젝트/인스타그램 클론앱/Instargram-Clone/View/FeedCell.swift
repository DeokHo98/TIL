//
//  FeedCell.swift
//  Instargram-Clone
//
//  Created by 정덕호 on 2022/03/22.
//

import UIKit

protocol FeedCellDelegate: AnyObject {
    func cellWantsToShowComments(_ cell: FeedCell, post: Post)
    func cell(_ cell: FeedCell, didLike post: Post)
    func cell(_ cell: FeedCell, wantsToShowProfileFor uid: String)
}


class FeedCell: UICollectionViewCell {

    static let identifier = "FeedCell"
    
    //MARK: - 속성
    
    weak var delegate: FeedCellDelegate?
    
    var viewModel: PostViewModel? {
        didSet {
            configure()
        }
    }
    
    //프로필 이미지입니다.
    private lazy var profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.backgroundColor = .lightGray
        let tap = UITapGestureRecognizer(target: self, action: #selector(showUserProfile))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    //닉네임의 버튼입니다.
    private lazy var  usernameButton: UIButton = {
       let bt = UIButton()
        bt.setTitle("베놈", for: .normal)
        bt.setTitleColor(.black, for: .normal)
        bt.titleLabel?.font = .boldSystemFont(ofSize: 13)
        bt.addTarget(self, action: #selector(showUserProfile), for: .touchUpInside)
        return bt
    }()
    
    //포스트한 이미지입니다.
    private let postImageView: UIImageView  = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.image = #imageLiteral(resourceName: "venom-7")
        return iv
    }()
    
    //댓글을 입력하는 버튼입니다.
    private lazy var commentButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "comment"), for: .normal)
        bt.tintColor = .black
        bt.addTarget(self, action: #selector(didTapComments), for: .touchUpInside)
        return bt
    }()
    
    //공유하기 버튼입니다.
    private lazy var shareButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "send2"), for: .normal)
        bt.tintColor = .black
        
        return bt
    }()
    
    //좋아요 버튼입니다.
     lazy var likeButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "like_unselected"), for: .normal)
        bt.tintColor = .black
        bt.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        return bt
    }()
    
    //좋아요 갯수를 나타내는 레이블입니다.
    private let likesLabel: UILabel = {
       let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: 13)
        return lb
    }()
    
    private let captionLabel: UILabel = {
       let lb = UILabel()
        lb.text = "내용은 무슨 내용을 넣어야할까요...."
        lb.font = .systemFont(ofSize: 14)
        return lb
    }()
    
    
    //좋아요버튼,댓글달기버튼,공유버튼을 스택뷰로 묶었습니다.
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [likeButton,commentButton,shareButton])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        return sv
        
    }()
    //MARK: - 라이프사이클
    
    //뷰를 올리고 레이아웃을 잡았습니다.
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12,paddingLeft: 12)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(usernameButton)
        usernameButton.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        
        addSubview(postImageView)
        postImageView.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8)
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        addSubview(stackView)
        stackView.anchor(top: postImageView.bottomAnchor, width: 120, height: 50)
        
        addSubview(likesLabel)
        likesLabel.anchor(top: stackView.bottomAnchor,left: leftAnchor,paddingTop: -4,paddingLeft: 8)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: likesLabel.bottomAnchor,left: leftAnchor,paddingTop: 8,paddingLeft: 8)
        
 
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        addSubview(divider)
        divider.anchor(left: leftAnchor,bottom: profileImageView.topAnchor,right: rightAnchor,paddingBottom: 7,height: 0.5)
        
        let bottomdivider = UIView()
        bottomdivider.backgroundColor = .lightGray
        addSubview(bottomdivider)
        bottomdivider.anchor(left: leftAnchor,bottom: postImageView.topAnchor,right: rightAnchor,height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - 도움 메서드
    func configure() {
        guard let viewModel = viewModel else {
            return
        }
        
        likesLabel.text = "좋아요 \(viewModel.likes)개"
        likeButton.tintColor = viewModel.likeButtonTintColor
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        captionLabel.text = viewModel.caption
        postImageView.sd_setImage(with: viewModel.imageUrl)
        profileImageView.sd_setImage(with: viewModel.userProfileImageUrl)
        usernameButton.setTitle(viewModel.username, for: .normal)
        
    }
    
    //MARK: - 셀렉터
    
    //닉네임을 터치할때 호출되는 셀렉터입니다.
    @objc func showUserProfile() {
        guard let viewModel = viewModel else {
            return
        }
        
        delegate?.cell(self, wantsToShowProfileFor: viewModel.post.ownerUid)

    }
    
    @objc func didTapComments() {
        guard let viewModel = viewModel else {
            return
        }
        delegate?.cellWantsToShowComments(self, post: viewModel.post)
    }
    
    @objc func didTapLike() {
        guard let viewModel = viewModel else {
            return
        }
        delegate?.cell(self, didLike: viewModel.post)
        
    }
    

}
