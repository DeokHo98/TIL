//
//  CardCollectionViewCell.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/27.
//

import SnapKit
import UIKit

class CardCollectionViewCell : UICollectionViewCell {
    static let registerID = "\(CardCollectionViewCell.self)"
    let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGray3
        return v
    }()
    let cardName: UILabel = {
        let lb = UILabel()
        lb.text = "카드 이름"
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 13, weight: .medium)
        return lb
    }()
    lazy var cardStackView: UIStackView = {
        let sv = UIStackView()
        [cardView,cardName].forEach { sv.addArrangedSubview($0)}
        sv.axis = .vertical
        sv.spacing = 7
        sv.alignment = .fill
        sv.distribution = .fill
        sv.backgroundColor = .white
        return sv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setLayout(){
        self.addSubview(cardStackView)
        cardStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
