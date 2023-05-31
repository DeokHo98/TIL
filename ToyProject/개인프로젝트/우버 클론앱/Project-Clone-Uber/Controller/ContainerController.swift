//
//  File.swift
//  Project-Clone-Uber
//
//  Created by 정덕호 on 2022/03/25.
//

import UIKit
import Firebase
class ContainerController: UIViewController {
    //MARK: - 속성
    
    private var homeController = HomeController()
    private var menuController: MenuController!
    private var isExpend = false
    private let blackView = UIView()
    private lazy var xOrigin = view.frame.width - 80
    
     var user: User? {
        didSet {
            guard let user = user else {return}
 
            configureMenuController(user: user)
        }
    }
    
    
    
    //MARK: - 라이프사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserDate()
        configureHomeController()

    }
    
    override var prefersStatusBarHidden: Bool {
        return isExpend
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .none
    }
    
    //MARK: - 셀렉터
    
    @objc func dismissMenu() {
        isExpend = false
        animateMenu(shouldExpand: isExpend)
    }
    
    //MARK: - 도움 메서드
    func signOut() {
        do {
           try Auth.auth().signOut()
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: loginViewController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
                
            }
        } catch {
            print("로그아웃 에러")
        }
    }
    
    
    func fetchUserDate() {
        guard let currrentUid = Auth.auth().currentUser?.uid else {return}
        Service.shared.fetchData(uid: currrentUid) { user in
            self.user = user
        }
    }
    
    func configureHomeController() {
        addChild(homeController)
        homeController.didMove(toParent: self)
        view.insertSubview(homeController.view, at: 1)
        homeController.delegate = self
        
    }
    
    
    func configureMenuController(user: User) {
        menuController = MenuController(user: user)
        addChild(menuController)
        menuController.didMove(toParent: self)
        //홈컨트롤러의 위치는 1에 있을것이고 메뉴컨트롤러의 위치는 0 에있을것이다.
        //쉽게 뷰계층에서 홈컨트롤러 아래에있는것이다.
        view.insertSubview(menuController.view, at: 0)
        menuController.delegate = self
        configureBlackView()
        
        
    }
    
    //옆으로 나오는 애니메이션주기
    func animateMenu(shouldExpand: Bool, completion: ((Bool) -> Void)? = nil) {
        
        if shouldExpand {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { [self] in
                self.homeController.view.frame.origin.x = xOrigin
                self.blackView.alpha = 1
            }, completion: nil)
        } else {
            self.blackView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.homeController.view.frame.origin.x = 0
            }, completion: completion)
        }
        
        anmateStatusBar()
    }
    
    
    func configureBlackView() {
        blackView.frame = CGRect(x: xOrigin, y: 0, width: 80, height: self.view.frame.height)
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.alpha = 0
        view.addSubview(blackView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        blackView.addGestureRecognizer(tap)
    }
    
    func anmateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
}

//MARK: - 홈델리게이트
extension ContainerController: HomeControllerDelegate {
    func handleMenuToggle() {
        isExpend.toggle()
        animateMenu(shouldExpand: isExpend)
    }
    
    
}

//MARK: - 메뉴 델리게이트
extension ContainerController: MenuControllerDelegates {
    func didSelect(option: MenuOptions) {
        isExpend.toggle()
        animateMenu(shouldExpand: isExpend) { [self] _ in
            switch option {
            case .yourTrips:
                print("123")
            case .settings:
                guard let user = self.user else {return}
                let controller = SettionController(user: user)
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            case .logOut:
                let alert = UIAlertController(title: nil, message: "정말 로그아웃 하시겠습니까?", preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: "네", style: .destructive, handler: { _ in
                    self.signOut()
                }))
                
                alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        

    }
    
    
}


extension ContainerController: SettingControllerDelegate {
    func updateUser(_ controller: SettionController) {
        self.user = controller.user
    }
}
