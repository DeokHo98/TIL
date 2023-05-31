//
//  MainTapController.swift
//  Instargram-Clone
//
//  Created by 정덕호 on 2022/03/22.
//

import UIKit
import Firebase
import YPImagePicker




class MainTabController: UITabBarController, UINavigationControllerDelegate {
    
     var user: User? {
        didSet {
            guard let user = user else {return}
            hud.dismiss()
            configureViewController(withUser: user)
        }
    }
    
    
    
    
    //MARK: - 라이프사이클
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        checkIfUserIsLoggedin()
        indicatorViewConfigure()
    }
    
    
    //MARK: - API
    //UserService의 함수를 실행시킨뒤에 탈출클로져로 받은 user 데이터를 프로필컨트롤러에 유저데이터에 담습니다.
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        UserService.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
    
    
    
    
    //로그인을 체그하는 메서드입니다.
    
    func checkIfUserIsLoggedin() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginViewController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    

    
    
    //MARK: - 도움메서드
    //이미지 픽커 후에 작동하는 메서드입니다.
    func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { items, cancelled in
            picker.dismiss(animated: false) {
                guard let selectedImage = items.singlePhoto?.image else { return }
                
                let controller = UploadPostController()
                controller.selectedImage = selectedImage
                controller.delegate = self
                controller.currentUser = self.user
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false, completion: nil)
            }
        }
    }
    
    func indicatorViewConfigure() {
        view.backgroundColor = .white
        hud.show(in: view)
    }
    
    func configureViewController(withUser user: User) {
        self.delegate = self
        
        //탭바컨트롤러를 설정하는 메서드입니다.
        
        let feed = templatNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: FeedController(user: user))
        
        let search = templatNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchController(user: user))
        
        let image = templatNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"), rootViewController: ImageSelectorController())
        
        let noti = templatNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: NotificationController())

        let profileController = ProfileController(user: user, loadingBool: true)
        let profile = templatNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: profileController)
        
        viewControllers = [feed, search, image, noti, profile]
        
        
        tabBar.tintColor = .black
        tabBar.backgroundColor = .clear
        
    }
    
    //탭바 아이템 이미지, 선택이미지, 색깔 등을 설정하는 메서드입니다.
    func templatNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage

        nav.navigationBar.tintColor = .black
        return nav
        
    }
}


//MARK: - 델리게이트
extension MainTabController: AuthebtucatuibDelegate {
    func authenticationComplete() {
        fetchUser()
        self.dismiss(animated: true, completion: nil)
    }
    
    
}



//MARK: - UITapbarcontroller 델리게이트
extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        //이미지 픽커를 등록하는 코드입니다.
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1
            
            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
            
            didFinishPickingMedia(picker)
        }
        return true
    }
}

//MARK: - 업로드 포스트 델리게이트

extension MainTabController: UploadPostControllerDelegate {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
        selectedIndex = 0
        controller.dismiss(animated: true, completion: nil)
        
        guard let feedNav = viewControllers?.first as? UINavigationController else {return}
        guard let feed = feedNav.viewControllers.first as? FeedController else {return}
        feed.handlerRefresh()
    }
    
    
}

