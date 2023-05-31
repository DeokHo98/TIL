//
//  CommentsController.swift
//  Instargram-Clone
//
//  Created by 정덕호 on 2022/04/06.
//

import UIKit

class CommentsController: UICollectionViewController {
    
    //MARK: -  속성
    
    private let post: Post
    
    private var comments = [Comment]()
    
    private lazy var commentInputView: CommentsInputAccView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommentsInputAccView(frame: frame)
        cv.delegate = self
        return cv
    }()
    
    
    //MARK: - 라이프사이클
    
    init(post: Post) {
        self.post = post
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confiureCollectionView()
        fetchComments()
    }
    
    override var inputAccessoryView: UIView? {
        get {return commentInputView}
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    //MARK: - 도움메서드
    
    func confiureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(CommentsCell.self, forCellWithReuseIdentifier: CommentsCell.identified)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }

    
    //MARK: -  API
    
    func fetchComments() {
        CommentService.fetchComments(postID: post.postID) { comments in
            self.comments = comments
            self.collectionView.reloadData()
        }
    }
}
//MARK: - 컬렉션 뷰 데이터소스
extension CommentsController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentsCell.identified, for: indexPath) as! CommentsCell
        cell.viewModel = CommentsViewModel(comment: comments[indexPath.row])
        return cell
    }
}

//MARK: - 컬렉션뷰 델리게이트
extension CommentsController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let uid = comments[indexPath.row].uid
        UserService.fetchUser(uid: uid) { user in
            let controller = ProfileController(user: user, loadingBool: false)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
}

//MARK: - 컬렉션뷰 레이아웃
extension CommentsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = CommentsViewModel(comment: comments[indexPath.row])
        let height = viewModel.size(width: view.frame.width).height + 32
        return CGSize(width: view.frame.width, height: height)
    }
}

//MARK: - CommentInputAccesoryViewDelegate
extension CommentsController: CommentInputAccesoryViewDelegate {
    func inputView(_ inputView: CommentsInputAccView, comment: String) {
    
        guard let tab = tabBarController as? MainTabController else { return }
        guard let currentUser = tab.user else {return}
        
        self.showLoader(true)
        
        CommentService.uploadComment(comment: comment, postID: post.postID, user: currentUser) { error in
            self.showLoader(false)
            inputView.clearCommentTextView()
            
            NotificationService.uploadNotification(uid: self.post.ownerUid, fromUser: currentUser, type: .comment, post: self.post)
        }
        
        
    }
    
}
