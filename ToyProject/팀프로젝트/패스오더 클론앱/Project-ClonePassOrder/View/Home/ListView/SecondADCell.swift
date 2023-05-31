//
//  SecondADCell.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/19.
//

import SnapKit
import UIKit

class SecondADCell: UICollectionViewCell {
    
    //MARK: - 식별자
    
    static let identifier: String = "SecondADCell"
     var viewModel: ADListViewModel? {
         didSet {
             setAtrribute()
             addContentScrollView(index: viewModel?.items.count ?? 0)
             timer?.invalidate()
             timer = Timer.scheduledTimer(
                withTimeInterval: 3, repeats: true
            ) { [weak self] _ in
                self?.ADTimer()
            }
         }
     }
    //MARK: - 프로퍼티
    
    private var timer: Timer?
    private var currentPage: Int = 0
    private var ADUrl = ["첫번째 링크","두번째링크","세번째링크","네번째링크","다섯번째링크"]
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.isPagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        let gesutre = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        sv.addGestureRecognizer(gesutre)
        sv.delegate = self
        return sv
    }()
    let countLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.alpha = 0.6
        lb.backgroundColor = .darkGray
        lb.textColor = .white
        lb.font = .systemFont(ofSize: 14)
        lb.clipsToBounds = true
        lb.layer.cornerRadius = 32 / 3
        return lb
    }()
    
    //MARK: - 라이프사이클
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 셀렉터 메서드
    
    @objc func scrollViewTapped() {
        let currentImageCount = Int(currentPage / Int(self.bounds.width))
        print(ADUrl[currentImageCount])
    }
    
    //MARK: - 메서드
    
    private func setLayout() {
        [scrollView,countLabel].forEach {
            self.addSubview($0)
        }
        scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        countLabel.snp.makeConstraints { make in
            make.width.equalTo(35)
            make.height.equalTo(22)
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    private func setAtrribute() {
        guard let count = self.viewModel?.items.count else {
            return
        }
        countLabel.text = "\(1)/\(count)"
    }
    private func addContentScrollView(index: Int) {
        guard let viewModel = viewModel else {
            return
        }
        for i in 0..<viewModel.count() {
            let imageView: UIImageView = UIImageView(frame: self.frame)
            let xPos = self.frame.width * CGFloat(i)
            imageView.frame = CGRect(
                x: xPos,
                y: 0,
                width: self.bounds.width,
                height: self.bounds.height
            )
            imageView.contentMode = .scaleAspectFill
            imageView.kf.setImage(with: viewModel.itemAtIndex(i).ADImageURL)
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 10
            scrollView.addSubview(imageView)
            scrollView.contentSize.width = imageView.frame.width * CGFloat(i + 1)
        }
    }
    private func ADTimer() {
        guard let count = self.viewModel?.count() else {
            return
        }
        let width = self.bounds.width
        if self.currentPage == Int(width * CGFloat(count - 1)) {
            self.currentPage = 0
            UIView.animate(withDuration: 0.2) {
                self.scrollView.contentOffset.x = 0
            }
        } else {
            self.currentPage += Int(width)
            UIView.animate(withDuration: 0.2) {
                self.scrollView.contentOffset.x += CGFloat(width)
            }
        }
    }
}

//MARK: - 스크롤뷰 델리게이트

extension SecondADCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let count = self.viewModel?.count() else {
            return
        }
        let pageText = Int(scrollView.contentOffset.x/self.bounds.width)
        currentPage = pageText * Int(self.bounds.width)
        countLabel.text = "\(pageText + 1)/\(count)"
    }
}

