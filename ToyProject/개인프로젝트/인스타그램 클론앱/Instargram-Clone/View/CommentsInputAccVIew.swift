//
//  File.swift
//  Instargram-Clone
//
//  Created by 정덕호 on 2022/04/06.
//

import UIKit

protocol CommentInputAccesoryViewDelegate: AnyObject {
    func inputView(_ inputView: CommentsInputAccView, comment: String)
}

class CommentsInputAccView: UIView {
    //MARK: - 속성
    
    weak var delegate: CommentInputAccesoryViewDelegate?
    
    private let commentTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholdertext = "댓글을 써주세요...."
        tv.font = .systemFont(ofSize: 15)
        tv.isScrollEnabled = false
        tv.placeholderShouldCenter = true
        return tv
    }()
    
    private let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("포스트", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleCommentUpload), for: .touchUpInside)
        return button
    }()
    
    
    
    
    //MARK: - 셀렉터
    
    @objc func handleCommentUpload() {
        delegate?.inputView(self, comment: commentTextView.text)
    }
    
    //MARK: - 라이프사이클
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        
        addSubview(postButton)
        postButton.anchor(top: topAnchor, right: rightAnchor, paddingRight: 8)
        postButton.setDimensions(height: 50, width: 50)
        
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: postButton.leftAnchor, paddingTop: 8,paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        addSubview(divider)
        divider.anchor(top: topAnchor,left: leftAnchor,right: rightAnchor, height: 0.5)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    
    
    //MARK: - 도움메서드
    
    func clearCommentTextView() {
        commentTextView.text = nil
        commentTextView.placeholderLabel.isHidden = false
    }
}
