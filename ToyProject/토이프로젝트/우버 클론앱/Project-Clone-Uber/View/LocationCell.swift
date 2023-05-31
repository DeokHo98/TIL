//
//  LocationInputCellTableViewCell.swift
//  Project-Clone-Uber
//
//  Created by 정덕호 on 2022/03/17.
//

import UIKit
import MapKit

class LocationCell: UITableViewCell {

    static let indentifier = "LocationCell"
    
    //MARK: - 속성
    var placmark: MKPlacemark? {
        didSet {
            titleLabel.text = placmark?.name
            addressLabel.text = placmark?.address

        }
    }
    
    var type: locationType? {
        didSet {
            titleLabel.text = type?.description
            addressLabel.text = type?.subtitle
        }
    }
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = "123 Main Street"
        return label
    }()
    
    var addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "123 Main Street, Washington, DC"
        return label
    }()
    //MARK: - 라이프 사이클

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, addressLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leadingAnchor, paddingLeft: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
