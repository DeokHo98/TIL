//
//  CollectionViewController.swift
//  Instargram-Clone
//
//  Created by 정덕호 on 2022/04/04.
//

import UIKit
import Firebase



class ProfileController: UICollectionViewController {
    //MARK: - 속성
   private var user: User
    private var posts = [Post]()
    var navigationButtonBool = true
    private let loadingView = UIView()
    private var loadingBool:Bool
    
    //MARK: - 라이프사이클
    init(user: User, loadingBool: Bool) {
        self.loadingBool = loadingBool
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if navigationButtonBool {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: #selector(handleLogout))
        }
        navigationItem.title = user.userName
        self.collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.identifier)
        self.collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeader.identifier)
        
        checkIfUserIsFollowed()
        fetchUserStats()
        fetchPosts()
        
        
        loadingView.backgroundColor = .white
        loadingView.frame = view.frame
        view.addSubview(loadingView)
        showLoader(true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPosts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if loadingBool {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) { [self] in
                loadingView.removeFromSuperview()
                showLoader(false)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) { [self] in
                loadingView.removeFromSuperview()
                showLoader(false)
            }
        }
        
    }

    
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let controller = LoginViewController()
            controller.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } catch {
            print("로그아웃 에러")
        }
    }
    
    //MARK: - API
    
    func checkIfUserIsFollowed() {
        UserService.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStats() {
        UserService.fetchUserStats(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
    
    func fetchPosts() {
        PostService.fetchPosts(forUser: user.uid) { [self] posts in
            self.posts = posts
            self.collectionView.reloadData()
        
        }
    }
    
    
//MARK: - 컬렉션뷰 데이터소스

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
        cell.viewModel = PostViewModel(post: posts[indexPath.row])
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeader.identifier, for: indexPath) as! ProfileHeader
        header.delegate = self
        header.viewModel = ProfileHeaderViewModel(user: user)
        return header
    }
    
}

// MARK: 컬렉션뷰 델리게이트
    
    extension ProfileController {
        override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let controller = FeedController(user: nil)
            controller.post = posts[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    



//MARK: - 컬렉션뷰 레이아웃
extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
    
}

//MARK: - 프로필 헤더 델리게이트

extension ProfileController: ProfileHeaderDelegate {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User) {
        guard let tab = tabBarController as? MainTabController else {return}
        guard let currentUser = tab.user else { return }
        
        
        
        if user.isCurrentUser {
            print("내 프로필입니다")
        } else if user.isFollowed {
            UserService.unfollowUser(uid: user.uid) { [self] error in
                self.user.isFollowed = false
                self.collectionView.reloadData()
                
            }
        } else {
            UserService.followUser(uid: user.uid) { [self] error in
                self.user.isFollowed = true
                self.collectionView.reloadData()
                NotificationService.uploadNotification(uid: user.uid, fromUser: currentUser, type: .follow)
                
            
                
            }
        }
        
    
    }
    
    
}
