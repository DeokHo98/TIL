//
//  ThirdListCell.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/19.
//

import UIKit
import CoreLocation

class ThirdListCell: UICollectionViewCell {
    //MARK: - 식별자
    
    static let identifier = "ThirdListCell"
    
    //MARK: - 프로퍼티
    
    var viewModel: CafeListViewModelItem? {
        didSet {
            setAtrribute()
        }
    }
   private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
       iv.contentMode = .scaleAspectFill
        return iv
    }()
   private let nameLabel: UILabel = UILabel().listLabel(
        text: "메가커피 양주점",
        color: .black,
        font: .boldSystemFont(ofSize: 18)
   )
   private let timeLabel: UILabel = UILabel().listLabel(
        text: "10분후 수령가능",
        color: .systemOrange,
        font: .boldSystemFont(ofSize: 16)
   )
    private let timeImage: UIImageView = UIImageView().listImageView(
        imageName: "timer",
        color: .systemOrange
    )
    private let distanceLabel: UILabel = UILabel().listLabel(
        text: "4.6km",
        color: .lightGray,
        font: .boldSystemFont(ofSize: 16)
    )
    private let distanceImage: UIImageView = UIImageView().listImageView(
        imageName: "location.north.fill",
        color: .lightGray
    )
    private let likeImage: UIImageView = UIImageView().listImageView(
        imageName: "heart.fill",
        color: .systemRed
    )
    private let likeLabel: UILabel = UILabel().listLabel(
        text: "0",
        color: .systemRed,
        font: .systemFont(ofSize: 16)
    )
    private let storyImage: UIImageView = UIImageView().listImageView(
        imageName: "bubble.right.fill",
        color: .white
    )
    private let storyLabel: UILabel = UILabel().listLabel(
        text: "0",
        color: .white,
        font: .systemFont(ofSize: 16)
    )
    private lazy var timeStackView: UIStackView = UIStackView(
        arrangedSubviews: [timeImage,timeLabel]
    )
    private lazy var distanceStackView: UIStackView = UIStackView(
        arrangedSubviews: [distanceImage,distanceLabel]
    )
    private lazy var likeStackView: UIStackView = UIStackView(
        arrangedSubviews: [likeImage,likeLabel]
    )
    private lazy var storyStackView: UIStackView = UIStackView(
        arrangedSubviews: [storyImage,storyLabel]
    )
    
    //MARK: - 라이프사이클
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 메서드
    
    private func setLayout() {
        [imageView,
         nameLabel,
         timeStackView,
         distanceStackView,
         likeStackView,
         storyStackView].forEach {
            self.addSubview($0)
        }
        self.listCellSetLayout(
            imageView: imageView,
            nameLabel: nameLabel,
            timeImage: timeImage,
            timeStackView: timeStackView,
            distanceImage: distanceImage,
            distanceStackView: distanceStackView,
            likeImage: likeImage,
            likeStackView: likeStackView,
            storyImage: storyImage,
            storyStackView: storyStackView,
            imageViewHeight: 220
        )
        CAGradientLayer().imageViewGradaient(imageView: imageView,bounds: bounds)
    }
    func setAtrribute() {
        guard let viewModel = viewModel else {
            return
        }
        guard let imageData = viewModel.cellImageData else {
            return
        }
        nameLabel.text = viewModel.name
        timeLabel.text = viewModel.orderTime
        distanceLabel.text = viewModel.distanceString(coordinate: CLLocation.coordinate())
        imageView.image = UIImage(data: imageData)
        storyLabel.text = "\(viewModel.storyCount)"
        likeLabel.text = "\(viewModel.favoriteCount)"
    }
}
