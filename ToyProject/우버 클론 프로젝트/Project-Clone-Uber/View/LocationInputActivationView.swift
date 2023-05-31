//
//  LocationInputActivationView.swift
//  Project-Clone-Uber
//
//  Created by 정덕호 on 2022/03/16.
//

import UIKit

protocol LocationInputActivationViewDelegate: AnyObject {
    func presentLocationInputView()
}

class LocationInputActivationView: UIView {
    
    //MARK: - 속성
    
    weak var delegate: LocationInputActivationViewDelegate?
    
    private let indeicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let placeholderLabel: UILabel = {
       let label = UILabel()
        label.text = "어디로 갈까요?"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()
    
    //MARK: - 라이프사이클
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addShadow()
        
        addSubview(indeicatorView)
        indeicatorView.centerY(inView: self,leftAnchor: leadingAnchor, paddingLeft: 16)
        indeicatorView.setDimensions(height: 6, width: 6)
        
        addSubview(placeholderLabel)
        placeholderLabel.centerY(inView: self, leftAnchor: indeicatorView.trailingAnchor, paddingLeft: 20)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlerShowLocationInputView))
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 셀렉터 메서드
    
    @objc func handlerShowLocationInputView() {
        delegate?.presentLocationInputView()
    }
    
}
