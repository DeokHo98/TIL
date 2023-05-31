//
//  Header.swift
//  AnimalHospital
//
//  Created by 정덕호 on 2022/04/16.
//

import UIKit

protocol DetailHeaderDelegate: AnyObject {
    func showEdit()
    
    func tapCall()
    
    func tabFavorite(imageView: UIImageView)
    
    func tabNavi()
    
}

class DetailHeader: UITableViewHeaderFooterView {
    static let identifier = "detailHeader"
    

    
    //MARK: - 속성
    

    var delegate: DetailHeaderDelegate?
    
    
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var callView: UIView = {
        let view = UIView().specialView(imageName: "phone.fill", text: "전화걸기")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapCall))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var editView: UIView = {
        let view = UIView().specialView(imageName: "pencil", text: "수정요청")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapEdit))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var favoriteView: UIView = {
        let view = UIView()
        view.setWidth(40)
        view.setHeight(40)
        view.layer.cornerRadius = 5
        view.backgroundColor = .systemBlue
        view.addSubview(image)
        image.centerX(inView: view)
        image.centerY(inView: view)
        let label = UILabel()
        label.text = "즐겨찾기"
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 18)
        view.addSubview(label)
        label.anchor(top: view.bottomAnchor, paddingTop: 10)
        label.centerX(inView: view)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapFavorite))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()
    
     let image: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "star.fill"))
        image.tintColor = .white
        image.setWidth(25)
        image.setHeight(25)
        return image
    }()
    
    private lazy var naviView: UIView = {
        let view = UIView().specialView(imageName: "arrow.right.square.fill", text: "T맵연결")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapNavi))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    private lazy var specialStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [callView,editView,favoriteView,naviView])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 50
        return sv
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.customGrayColor
        view.setHeight(8)
        return view
    }()
    
    
    
    
    //MARK: - 라이프사이클
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    //MARK: - 셀렉터메서드
    
    @objc func tapCall() {
        delegate?.tapCall()
        
    }
    
    @objc func tapEdit() {
        delegate?.showEdit()
    }
    
    @objc func tapFavorite() {
        delegate?.tabFavorite(imageView: self.image)
    }
    
    @objc func tapNavi() {
        delegate?.tabNavi()
    }
    
    //MARK: - 도움메서드
    private func configure() {
        let view = UIView()
        view.backgroundColor = .white
        
        self.addSubview(view)
        view.anchor(top:self.topAnchor,leading: self.leadingAnchor,bottom: self.bottomAnchor,trailing: self.trailingAnchor)
        
        view.addSubview(nameLabel)
        nameLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor,paddingLeading: 20)
        
        view.addSubview(specialStack)
        specialStack.anchor(top: nameLabel.bottomAnchor, paddingTop: 30)
        specialStack.centerX(inView: self)
        
        view.addSubview(bottomView)
        bottomView.anchor(top: specialStack.bottomAnchor,leading: self.leadingAnchor , trailing: self.trailingAnchor, paddingTop: 60)
        
        
    }
    
    private func deleteData() {
        
    }
    
    
   
    
}

