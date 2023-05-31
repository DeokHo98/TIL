//
//  PodcastViewCell.swift
//  TED_Clone
//
//  Created by 정덕호 on 2022/03/12.
//

import UIKit

//MARK: - 셀 커스텀
class PodCastCollectionViewCell: UICollectionViewCell {
    
    
    
    //indentifier의 실수를 방지하기 위해 변수로 만듭것입니다.
    static let identifier = "podCastCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cellSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var imageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    let labelView: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = ""
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    
    //MARK: - 도움 메서드
    private func cellSetting() {
        addSubview(imageView)
        imageView.anchor(top: self.topAnchor, left: self.leadingAnchor , bottom: self.bottomAnchor, right: self.trailingAnchor)
        
        addSubview(labelView)
        labelView.anchor(top: imageView.bottomAnchor, paddingTop: 10)
    }
    
    
    
}



//MARK: - 헤더 커스텀

class CollectionReusableView: UICollectionReusableView {
    
    static let identifier = "header"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        headerSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private let labelView: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "TED 팟 캐스트"
        label.font = .boldSystemFont(ofSize: 23)
        return label
    }()
    
    private func headerSetting() {
        addSubview(labelView)
        labelView.anchor(top: self.topAnchor, left: self.leadingAnchor, bottom: self.bottomAnchor, right: self.trailingAnchor,paddingLeft: 20,paddingBottom: 20)
    }
}
