//
//  TabBarController.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/17.
//

import UIKit
import Firebase
import CoreLocation

class TabBarController: UITabBarController {
    
    //MARK: - 프로퍼티
    private var locationManger = CLLocationManager()
    private var favoriteListViewModel: FavoriteListViewModel = FavoriteListViewModel()
    private lazy var cafeListViewModel: CafeListViewModel = CafeListViewModel()
    private var firstADListViewModel: ADListViewModel = ADListViewModel()
    private var secondADListViewModel: ADListViewModel = ADListViewModel()
    private let indicatorView: UIImageView = UIImageView().indicatorView()
    var serviceCount: Int = 0 {
        didSet {
            if serviceCount == 4 {
                setNavigation(
                    firstAD: self.firstADListViewModel,
                    secondAD: self.secondADListViewModel,
                    cafe: self.cafeListViewModel
                )
                setAttribute()
                indicatorView.removeFromSuperview()
            }
        }
    }
    
    //MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManger.requestWhenInUseAuthorization()
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.startUpdatingLocation()
        setImageView()
        setBinding()
        auth()
    }

    
    //MARK: - HelperFunction
    
    private func setImageView() {
        UIImageView.indicatorSetLayout(view: self.view, imageView: indicatorView)
    }
    private func setNavigation(firstAD: ADListViewModel,secondAD: ADListViewModel, cafe: CafeListViewModel) {
        let homeVC = HomeViewController(
            firstADViewModel: firstAD,
            secondADViewModel: secondAD,
            cafeViewModel: cafe
        )
        let orderHistoryVC = OrderHistoryViewController()
        let favoriteVC = FavoriteViewController(ADViewModel: secondAD, favoriteListViewModel: favoriteListViewModel)
        let qrCameraVC = qrCameraViewController()
        let myPasserVC = MyPasserTableViewController(style: .grouped)
        myPasserVC.viewDidLoad()
        let homeNavi = templatNavigation(
            title: "홈",
            image: UIImage(systemName: "cup.and.saucer.fill")!,
            rootViewController: homeVC
        )
        let orderHistoryNavi = templatNavigation(
            title: "주문내역",
            image: UIImage(systemName: "list.bullet.rectangle.portrait.fill")!,
            rootViewController: orderHistoryVC
        )
        let favoriteNavi = templatNavigation(
            title: "자주가요",
            image: UIImage(systemName: "heart.fill")!,
            rootViewController: favoriteVC
        )
        let qrCameraNavi = templatNavigation(
            title: "큐알주문",
            image: UIImage(systemName: "qrcode")!,
            rootViewController: qrCameraVC
        )
        let myPasserNavi = templatNavigation(
            title: "마이패써",
            image: UIImage(systemName: "smiley.fill")!,
            rootViewController: myPasserVC
        )
        viewControllers = [homeNavi,orderHistoryNavi,favoriteNavi,qrCameraNavi,myPasserNavi]
    }
    private func setAttribute() {
        tabBar.backgroundImage = UIImage()
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
        tabBar.addShadow()
    }
    private func templatNavigation(
        title: String,
        image: UIImage,
        rootViewController: UIViewController
    ) -> UINavigationController {
        let navi = UINavigationController(rootViewController: rootViewController)
        navi.tabBarItem.image = image
        navi.tabBarItem.title = title
        return navi
    }
    func setBinding() {
        UserViewModel.shared.userFetchEnd.bind { [weak self] _ in
            self?.serviceCount += 1
        }
        UserViewModel.shared.userServiceError.bind { [weak self] error in
            Toast.message(superView: self!.view, text: "서버연결에 실패했습니다 인터넷 연결을 확인해주세요")
            UserViewModel.shared.userFetch()
        }
        firstADListViewModel.ADServiceError.bind { [weak self] error  in
            Toast.message(superView: self!.view, text: "서버연결에 실패했습니다 인터넷 연결을 확인해주세요")
            self?.firstADListViewModel.fetchAD(collectionName: "SecondAD")
        }
        firstADListViewModel.ADfetchEnd.bind { [weak self] _ in
            self?.serviceCount += 1
        }
        secondADListViewModel.ADServiceError.bind { [weak self] error in
            Toast.message(superView: self!.view, text: "서버연결에 실패했습니다 인터넷 연결을 확인해주세요")
            self?.secondADListViewModel.fetchAD(collectionName: "FirstAD")
        }
        secondADListViewModel.ADfetchEnd.bind { [weak self] _ in
            self?.serviceCount += 1
        }
        cafeListViewModel.cafeServiceError.bind { [weak self] _ in
            Toast.message(superView: self!.view, text: "서버연결에 실패했습니다 인터넷 연결을 확인해주세요")
            self?.cafeListViewModel.fetchCafe()
        }
        cafeListViewModel.cafeFetchEnd.bind { [weak self] _ in
            self?.serviceCount += 1
        }
        favoriteListViewModel.favoriteError.bind { [weak self] _ in
            Toast.message(superView: self!.view, text: "서버연결에 실패했습니다 인터넷 연결을 확인해주세요")
            self?.favoriteListViewModel.fetchFavoriteID()
        }
        favoriteListViewModel.fetchFavoriteIDSuccess.bind { [weak self] ID in
            self?.favoriteListViewModel.fetchCafeList(ID: ID)
        }
    }
    func auth() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                guard let delegate = sceneDelegate else {
                    return
                }
                let vc = UINavigationController(rootViewController: LoginViewController())
                delegate.window?.rootViewController = vc
            }
        } else {
            cafeListViewModel.fetchCafe()
            UserViewModel.shared.userFetch()
            firstADListViewModel.fetchAD(collectionName: "SecondAD")
            secondADListViewModel.fetchAD(collectionName: "FirstAD")
            favoriteListViewModel.fetchFavoriteID()
        }
    }
    
        
    
    

}
