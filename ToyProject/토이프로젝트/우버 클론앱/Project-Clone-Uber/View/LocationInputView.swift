//
//  LocationInputView.swift
//  Project-Clone-Uber
//
//  Created by 정덕호 on 2022/03/17.
//

import UIKit
import SwiftUI

protocol LocationInputViewDelegate: AnyObject {
    func dismissLocationInputView()
    func executeSearch(query: String)
}

class LocationInputView: UIView {

    //MARK: - 속성
    
    var user: User? {
        didSet{
            guard let user = user else {return}
            titleLabel.text = user.fullName
        }
    }
    
    weak var delegate: LocationInputViewDelegate?
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "backbutton2")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "wjdejrgh"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let startLocationIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let linkingView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    private let destinationIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var startingLocationTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "현재 위치"
        tf.backgroundColor = .systemGroupedBackground
        tf.isEnabled = false
        tf.font = .systemFont(ofSize: 14)
        
        let paddingView = UIView()
        paddingView.setDimensions(height: 30, width: 8)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        return tf
    }()
    
    private lazy var destinationLocationTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "목적지를 검색해주세요"
        tf.backgroundColor = .lightGray
        tf.returnKeyType = .search
        tf.font = .systemFont(ofSize: 14)
        tf.delegate = self
        let paddingView = UIView()
        paddingView.setDimensions(height: 30, width: 8)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        tf.text = "커피"
        return tf
    }()
    //MARK: - 라이프사이클
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addShadow()
        
        backgroundColor = .white
        
        addSubview(backButton)
        backButton.anchor(top: topAnchor, leading: leadingAnchor,paddingTop: 44, paddingLeading: 12, width: 24, height: 25)
        
        addSubview(titleLabel)
        titleLabel.centerY(inView: backButton)
        titleLabel.centerX(inView: self)
        
        addSubview(startingLocationTextField)
        startingLocationTextField.anchor(top: backButton.bottomAnchor, leading: leadingAnchor, trailng: trailingAnchor, paddingTop: 12, paddingLeading: 40,paddingTrailing: 40,height: 30)
        
        addSubview(destinationLocationTextField)
        destinationLocationTextField.anchor(top: startingLocationTextField.bottomAnchor, leading: leadingAnchor, trailng: trailingAnchor, paddingTop: 12, paddingLeading: 40,paddingTrailing: 40,height: 30)
        
        addSubview(startLocationIndicatorView)
        startLocationIndicatorView.centerY(inView: startingLocationTextField, leftAnchor: leadingAnchor, paddingLeft: 20)
        startLocationIndicatorView.setDimensions(height: 6, width: 6)
        startLocationIndicatorView.layer.cornerRadius = 6 / 2
        
        addSubview(destinationIndicatorView)
        destinationIndicatorView.centerY(inView: destinationLocationTextField, leftAnchor: leadingAnchor, paddingLeft: 20)
        destinationIndicatorView.setDimensions(height: 6, width: 6)
        
        addSubview(linkingView)
        linkingView.centerX(inView: startLocationIndicatorView)
        linkingView.anchor(top: startLocationIndicatorView.bottomAnchor, bottom: destinationIndicatorView.topAnchor, paddingTop: 4, paddingBottom: 4, width: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - 셀렉터
    
    @objc func handleBackTap() {
        
        delegate?.dismissLocationInputView()
    }
    
    
    
}

extension LocationInputView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text else {return false}
        delegate?.executeSearch(query: query)
        textField.endEditing(true)
        return true
    }
}
