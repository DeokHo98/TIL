//
//  FeedController.swift
//  Instargram-Clone
//
//  Created by 정덕호 on 2022/03/22.
//

import UIKit
import Firebase
import YPImagePicker




class FeedController: UICollectionViewController {
    
    //MARK: - 속성
    
    var user: User?
    
    let refresher = UIRefreshControl()
    
    
    //MARK: - 라이프사이클
    
    
    private var posts = [Post]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
   
    
    var post: Post?
    
    
    
    init(user: User?) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPosts()
    
    
        
    }
    
    //MARK: - Api
    
    func fetchPosts() {
        PostService.fetchPosts { [self] posts in
            guard post == nil else {return}
            
            self.posts = posts
            self.collectionView.refreshControl?.endRefreshing()
            self.checkIfUserLikedPosts()
            self.collectionView.reloadData()
            
            
        }
    }
    
    func checkIfUserLikedPosts() {
        self.posts.forEach { post in
            PostService.checkIfUserLikedPost(post: post) { didlike in
                if let index = self.posts.firstIndex(where: {
                    $0.postID == post.postID
                }) {
                    self.posts[index].didLike = didlike
                }
            }
        }
    }
    
    
 
    //MARK: - 도움 메서드
    
    func configureUI() {
        view.backgroundColor = .white

        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.identifier)
        
        
        
        navigationItem.title = "피드"
        
        
        refresher.addTarget(self, action: #selector(handlerRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
        
    }
    
        
    
    
    //MARK: - 셀렉터 메서드
    
 
    
    @objc func handlerRefresh() {
        posts.removeAll()
        fetchPosts()
    }
    

    
    
}
//MARK: - 컬렉션뷰 데이터소스

extension FeedController {
    //컬렉션뷰의 숫자의 갯수를 설정합니다.
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post == nil ? posts.count : 1
    }
    
    //컬렉션뷰의 나타낼 셀을 설정합니다.
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: indexPath) as! FeedCell
        
        
        cell.delegate = self
        
        if let post = post {
            cell.viewModel = PostViewModel(post: post)
            
        } else {
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
        }
        
        return cell
        
 
    }
    
    
    
    
    
}

//MARK: - 컬렉션뷰 레이아웃
extension FeedController: UICollectionViewDelegateFlowLayout {
    //컬렉션뷰의 사이즈를 조정하는 플로우 레이아웃 델리게이트입니다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        let height = width + 8 + 40 + 8 + 50 + 60
        
        return CGSize(width: width, height: height)
    }
    
 
    
}


//MARK: - 피드셀 델리게이트

extension FeedController: FeedCellDelegate {
    func cell(_ cell: FeedCell, wantsToShowProfileFor uid: String) {
        UserService.fetchUser(uid: uid) { user in
            let controller = ProfileController(user: user, loadingBool: false)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func cell(_ cell: FeedCell, didLike post: Post) {
        guard let tab = tabBarController as? MainTabController else {return}
        guard let user = tab.user else {return}
        cell.viewModel!.post.didLike.toggle()
        
        
        if post.didLike {
            PostService.unlikePost(post: post) { error in
                cell.likeButton.setImage(UIImage(named: "like_unselected"), for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.post.likes = post.likes - 1
            }
        } else {
            PostService.likePost(post: post) { error in
                cell.likeButton.setImage(UIImage(named: "like_selected"), for: .normal)
                cell.likeButton.tintColor = .systemRed
                cell.viewModel?.post.likes = post.likes + 1
                
                NotificationService.uploadNotification(uid: post.ownerUid, fromUser: user, type: .like, post: post)
            }
        }
    }
    
    func cellWantsToShowComments(_ cell: FeedCell, post: Post) {
        let controller = CommentsController(post: post)
        controller.navigationItem.title = "댓글"
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}


