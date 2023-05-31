//
//  NotificationController.swift
//  Instargram-Clone
//
//  Created by 정덕호 on 2022/03/22.
//

import UIKit

class NotificationController: UITableViewController {
    
    //MARK: -  속성
    
    private var notifications = [Notification]() {
        didSet{
            tableView.reloadData()
        }
    }
    private let loadingView = UIView()
    
    //MARK: - 라이프사이클
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        fetchNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notifications.removeAll()
        fetchNotifications()
    }
    
    
    
    
    //MARK: - API
    
    func fetchNotifications() {
        NotificationService.fetchNotification { [self] noti in
            notifications = noti
            checkIfUserIsFollowed()
            
        }
    }
    
    func checkIfUserIsFollowed() {
        notifications.forEach { noti in
            guard noti.type == .follow else { return }
            UserService.checkIfUserIsFollowed(uid: noti.uid) { [self] isfollowed in
                if let index = notifications.firstIndex(where: {
                    $0.id == noti.id
                }) {
                    self.notifications[index].userIsFollowed = isfollowed
                }
            }
        }
    }
    
    //MARK: - 도움메서드
    func configure() {
        view.backgroundColor = .white
        navigationItem.title = "알림"
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.identifier)
        tableView.rowHeight = 64
        tableView.separatorStyle = .none
    }
    
}


//MARK: - 데이터소스
extension NotificationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.identifier, for: indexPath) as! NotificationCell
        cell.viewModel = NotificationViewModel(notification: notifications[indexPath.row])
        cell.delegate = self
        return cell
    }
}


//MARK: - 테이블뷰 델리게이트

extension NotificationController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLoader(true)
        let uid = notifications[indexPath.row].uid
        UserService.fetchUser(uid: uid) { user in
            self.showLoader(false)
            let controller = ProfileController(user: user, loadingBool: false)
            controller.navigationButtonBool = false
            self.navigationController?.pushViewController(controller, animated: true)
          
        }
    }
}


//MARK: - 노티피케이션셀 델리게이트

extension NotificationController: NotificationCellDelegate {
    func cell(_ cell: NotificationCell, wantsToFollow uid: String) {
        showLoader(true)
        UserService.followUser(uid: uid) { _ in
            self.showLoader(false)
            cell.viewModel?.notification.userIsFollowed.toggle()
        }
        
    }
    
    func cell(_ cell: NotificationCell, wantstUnfollow uid: String) {
        showLoader(true)
        UserService.unfollowUser(uid: uid) { _ in
            self.showLoader(false)
            cell.viewModel?.notification.userIsFollowed.toggle()
        }
    }
    
    func cell(_ cell: NotificationCell, wantsToViewPost postId: String) {
        showLoader(true)
        PostService.fetchPost(withPostId: postId) { post in
            self.showLoader(false)
            let controller = FeedController(user: nil)
            controller.post = post
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
}
