//
//  HomeController.swift
//  AnimalHospital
//
//  Created by 정덕호 on 2022/04/14.
//

import UIKit
import CoreLocation
import NMapsMap


class HomeController: UIViewController {
    
    
    
    //MARK: - 속성
    
    //병원 뷰모델
    var hospitalViewModel = HospitalViewModel()
    
    //네이버맵
    private let naverMapView = NMFMapView()
    
    //네이버맵 마커
    private let marker = NMFMarker()
    
    //위치 매니저
    var locationManger = CLLocationManager()
    
    var locationManagerBool = true
    
    
    //서치
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.backgroundColor = .white
        button.setTitle("새로운 위치 검색하기", for: .normal)
        button.setTitleColor( .lightGray, for: .normal)
        button.addShadow()
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(searchButtonTap), for: .touchUpInside)
        return button
    }()
    
    
    //내 위치 버튼
    private let locationButton: UIButton = {
        let button = UIButton().imageButton(image: "location.fill", color: .systemBlue)
        button.addTarget(self, action: #selector(locationButtonTap), for: .touchUpInside)
        return button
    }()
    
    //즐겨찾기 버튼
    private let favoriteButton: UIButton = {
        let button = UIButton().imageButton(image: "star.fill", color: .systemYellow)
        button.addTarget(self, action: #selector(favoritButtonTap), for: .touchUpInside)
        return button
    }()
    
    //쩨보하기 버튼
    private let reportButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("제보", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.addShadow()
        button.setHeight(50)
        button.setWidth(50)
        button.layer.cornerRadius = 50 / 2
        button.addTarget(self, action: #selector(tapReportButton), for: .touchUpInside)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()
    
    
    //카메라 줌 인아웃 버튼
    private let zoominButton: UIButton = {
        let button = UIButton().imageButton(image: "plus", color: .systemBlue)
        button.addTarget(self, action: #selector(zoomIn), for: .touchUpInside)
        return button
    }()
    
    private let zommOutbutton: UIButton = {
        let button = UIButton().imageButton(image: "minus", color: .systemBlue)
        button.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [zoominButton, zommOutbutton])
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    //로딩뷰
    private let loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        let image = UIImageView()
        image.image = UIImage(named: "배경")
        view.addSubview(image)
        image.centerY(inView: view)
        image.centerX(inView: view)
        image.setHeight(300)
        image.setWidth(300)
        let label = UILabel()
        label.text = "데이터를 받는중입니다..."
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        view.addSubview(label)
        label.anchor(top: image.bottomAnchor,paddingTop: -40)
        label.centerX(inView: view)
        return view
    }()
    
    
    
    
    //MARK: - 디테일뷰 모달 관련 속성
    
    
    
    // 드래그 되는 뷰
    private let containerView = DetailView()
    
    //모달의 디폴트 높이
    private var defaultHeight: CGFloat = UIScreen.main.bounds.height / 2.5
    
    //모달이 꺼지는 높이
    private let dismissibleHeight: CGFloat = UIScreen.main.bounds.height / 2.8
    
    //모달이 올라가는 최대 위치
    private let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height
    
    //모달이 움직일때 순간 높이 디폴트 높이랑 같게 해야함
    private var currentContainerHeight: CGFloat = UIScreen.main.bounds.height / 2.5
    
    //동적 높이
    private var containerViewHeightConstraint: NSLayoutConstraint?
    private var containerViewBottomConstraint: NSLayoutConstraint?
    
    
    //MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        UIconfigure()
        mapConfigure()
        containerViewconfigure()
        setupPanGesture()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if locationManagerBool {
            locationManagerBool = false
            locationMangerConfirm()
            hospitalViewModelClosure()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
    }
   
    
    
    
    //MARK: - 셀렉터메서드
    //location버튼을 클릭하면 권한상태에 따라 현재 위치로 이동하는 메서드
    @objc private func locationButtonTap() {
        switch locationManger.authorizationStatus {
        case .denied:
            diniedAlert()
        case .authorizedAlways:
            marker.mapView = nil
            naverMapView.positionMode = .direction
            cameraZoom()
        case .authorizedWhenInUse:
            marker.mapView = nil
            naverMapView.positionMode = .direction
            cameraZoom()
        case .notDetermined:
            break
        case .restricted:
            diniedAlert()
        @unknown default:
            break
        }
    }
    
    
    //서치 버튼 눌렀을때
    @objc func searchButtonTap() {
        let vc = SearchViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //줌인 줌아웃 버튼 눌렀을때
    @objc private func zoomIn() {
        let current = naverMapView.zoomLevel
        let camZoom = NMFCameraUpdate(zoomTo: current + 1)
        naverMapView.moveCamera(camZoom)
    }
    
    @objc private func zoomOut() {
        let current = naverMapView.zoomLevel
        let camZoom = NMFCameraUpdate(zoomTo: current - 1)
        naverMapView.moveCamera(camZoom)
    }
    
    // 즐겨찾기 버튼 눌렀을때
    @objc private func favoritButtonTap() {
        let vc = FavoriteController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //제보하기 버튼을 눌렀을때
    @objc private func tapReportButton() {
        let vc = ReportViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - 디테일뷰 모달관련 셀렉터 메서드
    
    //제스처를 맨위로 드래그하면 마이너스값이되고 그반대로하면 플러스값이됨
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        
        //드래그 방향을 가져옵니다
        let isDraggingDown = translation.y > 0
        
        //새로운 높이는 현재 높이 - 제스처한만큼의 높이
        let newHeight = currentContainerHeight - translation.y
        
        //제스처 상태에 따라 처리합니다.
        switch gesture.state {
        case .changed:
            //드래그할때 발생합니다
            if newHeight < maximumContainerHeight {
                //높이 제약조건을 업데이트
                containerViewHeightConstraint?.constant = newHeight
                
                if isDraggingDown {
                    //뷰가 아래로로 내려가는 순간 새로운레이아웃을 만듭니다.
                    self.containerView.showDown()
                }
            }
        case .ended:
            //드래그를 멈추면 발생합니다
            
            //새로운 높이가 최소값 미만이면 뷰를 닫습니다.
            if newHeight < dismissibleHeight {
                self.animateDismissView()
                
            }
            //새로운 높이가 기본값보다 낮으면 최소값 이상이면 기본값으로 돌립니다
            else if newHeight < defaultHeight {
                animateContainerHeight(defaultHeight)
                
                
            }
            //새로운 높이가 기본값보다 높고 최대값보다 낮은상태로 "내려간다면" 기본값으로 내립니다.
            else if newHeight < maximumContainerHeight && isDraggingDown {
                animateContainerHeight(defaultHeight)
                self.containerView.showDown()
            }
            //새로운 높이가 기본값보다 높고 최대값보다 낮은상태로 "올라간다면" 뷰를 최대치로 올립니다.
            else if newHeight > defaultHeight && !isDraggingDown {
                animateContainerHeight(maximumContainerHeight)
                //뷰가 최대치로 올라간다면 일정 시간을 두고 새로운 레이아웃을 만듭니다.
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) { [weak self] in
                    self?.containerView.showUp()
                }
            }
        default:
            break
        }
        
        
    }
    
    //MARK: - 도움메서드
    
    //UI구성 메서드
    private func UIconfigure() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        
        view.addSubview(naverMapView)
        naverMapView.frame = view.frame
        
        
        view.addSubview(searchButton)
        searchButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,leading: view.leadingAnchor,trailing: view.trailingAnchor,paddingLeading: 10,paddingTrailing: 10,height: 50)
        
        
        view.addSubview(locationButton)
        locationButton.anchor(top: searchButton.bottomAnchor, leading: view.leadingAnchor, paddingTop: 30, paddingLeading: 20)
        
        view.addSubview(favoriteButton)
        favoriteButton.anchor(top: searchButton.bottomAnchor, trailing: view.trailingAnchor, paddingTop: 30, paddingTrailing: 20)
        
        view.addSubview(reportButton)
        reportButton.anchor(top: locationButton.bottomAnchor, leading: view.leadingAnchor, paddingTop: 20, paddingLeading: 20)
        
        view.addSubview(buttonStack)
        buttonStack.centerY(inView: view)
        buttonStack.anchor(trailing: view.trailingAnchor, paddingTrailing: 20)
        
        loadingView.frame = view.frame
        view.addSubview(loadingView)
        
        
    }
    
    // 로케이션 매니저 구성 메서드
    private func mapConfigure() {
        locationManger.delegate = self
        locationManger.requestWhenInUseAuthorization()
        
    }
    
    //현재 권항 상태를 확인하는 메서드
    private func locationMangerConfirm() {
        switch locationManger.authorizationStatus {
        case .denied:
            break
        case .authorizedAlways:
            cameraZoom()
            naverMapView.positionMode = .direction
        case .authorizedWhenInUse:
            cameraZoom()
            naverMapView.positionMode = .direction
        case .notDetermined:
            break
        case .restricted:
            break
        @unknown default:
            break
        }
    }
    
    //현재 위치 권한이 없는 상태일때 얼럿을 띄어 위치권한 설정화면으로 넘어가는 얼럿 메서드
    private func diniedAlert() {
        let alert = UIAlertController(title: "위치권한 설정을 다시 설정해주세요", message: "설정 > 24시 동물병원 에서 위치서비스를 허용하시면 현재위치 기준의 정보를 보실수 있습니다", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "네", style: .default) { action in
            UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL)
        }
        
        let noAction = UIAlertAction(title: "아니요", style: .default, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //병원뷰모델의 클로저
    private func hospitalViewModelClosure() {
        hospitalViewModel.lodingEnd = { [weak self] in
            self?.lodingViewOFF()
        }
        
        hospitalViewModel.fetch()
    }
    
    
    //카메라 줌 메서드
    private func cameraZoom() {
        let camZoom = NMFCameraUpdate(zoomTo: 12)
        naverMapView.moveCamera(camZoom)
    }
    
    private func selectCameraZoom() {
        let camZoom = NMFCameraUpdate(zoomTo: 13)
        naverMapView.moveCamera(camZoom)
        
    }
    
    //로딩뷰 메서드
    private func lodingViewOFF() {
        //네이버 공식문서에서 같은 이미지를 쓰는경우 오버레이 이미지를 하나만 생성해서 사용해야한다고 합니다.
        let image = NMFOverlayImage(name: "마커이미지")
        loadingView.removeFromSuperview()
        DispatchQueue.global(qos: .default).async { [weak self] in
            for models in self!.hospitalViewModel.models {
                let marker = NMFMarker()
                marker.iconImage = image
                //아래 코멘트: 코멘트해제시 마커가 겹칠경우 하나의 마커로 줄어듬
                //marker.isHideCollidedMarkers = true
                marker.position = NMGLatLng(lat: models.x, lng: models.y)
                marker.width = 40
                marker.height = 60
                marker.touchHandler = { [weak self] (ovrlay: NMFOverlay) -> Bool in
                    self?.marker.mapView = nil
                    self?.containerView.viewModel = DetailViewModel(model: models)
                    self?.animatePresentContainer()
                    self?.selectCameraZoom()
                    let camUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: models.x, lng: models.y))
                    self?.naverMapView.moveCamera(camUpdate)
                    return true
                }
                DispatchQueue.main.async { [weak self] in
                    marker.mapView = self?.naverMapView
                }
            }
        }
    }
    
    
    
    
    //MARK: - 디테일뷰 모달관련 도움 메서드
    
    
    private func containerViewconfigure() {
        containerView.delegate = self
        containerView.frame = view.frame
        
        currentContainerHeight = view.frame.height / 2
        view.addSubview(containerView)
        containerView.anchor(leading: view.leadingAnchor, trailing: view.trailingAnchor)
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
        
        containerView.addShadow()
        currentContainerHeight = defaultHeight
        
    }
    
    //MARK: - 디테일뷰 제스처 도움메서드
    
    private func setupPanGesture() {
        //뷰 전체에 제스처를 추가
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        containerView.addGestureRecognizer(panGesture)
    }
    
    
    private func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            //현재 컨테이너 높이를 업데이트합니다
            self.containerViewHeightConstraint?.constant = height
            //레이아웃 새로고침
            self.view.layoutIfNeeded()
        }
        //현재높이를 저장
        currentContainerHeight = height
    }
    
    private func animatePresentContainer() {
        UIView.animate(withDuration: 0.4) {
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
            self.containerViewHeightConstraint?.constant = self.defaultHeight
        }
    }
    
    
    
    //뷰를 닫습니다
    private func animateDismissView() {
        UIView.animate(withDuration: 0.4) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            self.view.layoutIfNeeded()
            self.containerView.viewModel = nil
            self.containerView.imageView.image = nil
        }
    }
    
    
}

//MARK: - CLLocation 델리게이트
extension HomeController: CLLocationManagerDelegate {
    //권한상태가 바뀐경우 실행되는 델리게이트 메서드
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationMangerConfirm()
    }
    
}

//MARK: - 서치뷰 델리게이트
extension HomeController: SearchViewDelegate {
    func locationData(lating: NMGLatLng) {
        marker.mapView = nil
        marker.position = lating
        marker.iconImage = NMF_MARKER_IMAGE_BLACK
        marker.iconTintColor = .systemRed
        marker.mapView = naverMapView
        let camUpdate = NMFCameraUpdate(scrollTo: lating)
        naverMapView.moveCamera(camUpdate)
        cameraZoom()
    }
    
}

//MARK: - 디테일뷰 델리게이트
extension HomeController: DetailViewDelegate {
    
    
    
    
    func showEditView(name: String) {
        let vc = EditController()
        vc.name = name
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollDown() {
        animateContainerHeight(defaultHeight)
        containerView.showDown()
    }
}

//MARK: - 즐겨찾기 델리게이트

extension HomeController: FavoriteDelegate {
    func seleted(name: String, address: String) {
        let model = hospitalViewModel.models.filter {
            return $0.name == name && $0.address == address
        }
        let camUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: model[0].x, lng: model[0].y))
        naverMapView.moveCamera(camUpdate)
        selectCameraZoom()
        animatePresentContainer()
        containerView.viewModel = DetailViewModel(model: model[0])
        
        
        
    }
    
    
}

