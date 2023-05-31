//
//  MyPasserCell.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/21.
//

import UIKit

class MyPasserCell: UITableViewCell {
    
    //MARK: - 식별자
    static let identifier: String = "MyPasserCell"
    
    //MARK: - 프로퍼티
     let label: UILabel = {
        let lb = UILabel()
        lb.textColor = .darkGray
        lb.font = .systemFont(ofSize: 18)
        return lb
    }()
    
    //MARK: - 라이프사이클

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setLayout()
    }
    
    //MARK: - 메서드
    private func setLayout() {
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(20)
        }
    }

}
