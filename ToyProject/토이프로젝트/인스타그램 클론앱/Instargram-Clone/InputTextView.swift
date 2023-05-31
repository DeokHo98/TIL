//
//  InputTextView.swift
//  Instargram-Clone
//
//  Created by 정덕호 on 2022/04/05.
//


import UIKit

class InputTextView: UITextView {
    //MARK: - 속성
    var placeholdertext: String? {
        didSet {
            placeholderLabel.text = placeholdertext
        }
    }
    
    
     let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    var placeholderShouldCenter = true {
        didSet {
            if placeholderShouldCenter {
                placeholderLabel.anchor(left: leftAnchor,right: rightAnchor,paddingLeft: 8)
                placeholderLabel.centerY(inView: self)
            } else {
                placeholderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 6, paddingLeft: 8)
            }
        }
    }
    
    //MARK: - 셀렉터 메서드
    
    @objc func handleTextDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    //MARK: - 라이프사이클
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeholderLabel)

        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
