//
//  HomeController.swift
//  Project-Clone-Uber
//
//  Created by 정덕호 on 2022/03/16.
//

import UIKit
import Firebase
import MapKit
import SwiftUI

protocol HomeControllerDelegate: AnyObject {
    func handleMenuToggle()
}

private enum ActionButtonConfiuration {
    case showMenu
    case dismissActionView
    
    init() {
        self = .showMenu
    }
}

private enum AnnotationType: String {
    case pickup
    case destination
}

class HomeController: UIViewController {
    
    //MARK: - 속성
    
    weak var delegate: HomeControllerDelegate?
    
    private let mapView = MKMapView()
    
    private let locationManager = LocationHnadler.shared.locationManager
    
    
    private let inputActivationView: LocationInputActivationView = {
        let view = LocationInputActivationView()
        return view
    }()
    
    private let loccationInputView = LocationInputView()
    
    private let tableview = UITableView(frame: .zero, style: .grouped)

    
    private final let locationInputViewheight: CGFloat = 200
    
     var user: User? {
        didSet {
            guard let user = user else {return}
            loccationInputView.user = user
            if user.accountType == .passenger {
                fetchDriver()
                configureLocationInputActivationView()
                dobserveCurrentTrip()
                
            } else {
                observeTrips()
            }
        }
    }
    
    private var trip: Trip? {
        didSet {
            guard let user = user else {return}
            
            if user.accountType == .driver {
                guard let trip = trip else {return}
                let controller = PickupController(trip: trip)
                controller.delegate = self
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            } else {
                
            }
        }
    }
    
    private var searchResults = [MKPlacemark]()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "baseline_menu_black_36dp")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private var actionButtonConfig = ActionButtonConfiuration()
    
    private var reute: MKRoute?
    
    private let rideActionView = RideActionView()
    

    
    //MARK: - 라이프사이클

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        loccationInputView.delegate = self
        
        
        makeLayout()
        enableLocationServices()
        configureTableView()
        fetchUserData()
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let trip = trip else {return}
        print(trip.state)
    }
    
//MARK: - 셀렉터
    
    @objc func actionButtonPressed() {
        switch actionButtonConfig {
        case .showMenu:
            delegate?.handleMenuToggle()
        case .dismissActionView:
            print("디스미스메뉴")
            removeAnnotationsAndOverlay()
            mapView.showAnnotations(mapView.annotations, animated: true)
            
            UIView.animate(withDuration: 0.5) {
                self.inputActivationView.alpha = 1
                self.configureActionButtonSet(config: .showMenu)
                self.presentRideAcitonView(shouldShow: false)
            }

        }
        
    }

    
//MARK: - 공용 API
    
    
    
    
    func fetchUserData() {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        Service.shared.fetchData(uid: currentUid) { [weak self] user in
            self?.user = user
        }
    }
    
    //MARK: - 사용자 API
    

    
    
    //위치를 표시하는 방뻐
    func fetchDriver() {
        guard let location = locationManager?.location else { return }
        PassengrService.shared.fetchDriver(location: location) { driver in
            guard let coordinate = driver.location?.coordinate else {return}
            let annotation = DriverAnnotation(uid: driver.uid, corrdinate: coordinate)
            var driverIsVisible: Bool {
                return self.mapView.annotations.contains { annotation -> Bool in
                    guard let driverAnno = annotation as? DriverAnnotation else {return false}
                    if driverAnno.uid == driver.uid {
                        driverAnno.updateAnnotationPosition(withCoordinate: coordinate)
                        self.zoomForActiveTrip(withDriverUid: driver.uid)
                        return true
                    }
                    return false
                }
            }
            
            if !driverIsVisible {
                self.mapView.addAnnotation(annotation)
            }

        }
         
    }
    
    
    //MARK: - 드라이버 API
    
    func observeTrips() {
        DriverService.shared.observeTrips { trip in
            self.trip = trip
        }
    }
    
    func observeCanceldTrip(trip: Trip) {
        DriverService.shared.observeTripCancelled(trip: trip) {
            self.removeAnnotationsAndOverlay()
            self.presentRideAcitonView(shouldShow: false)
            self.centerMapOnuserLocation()
            self.presentAlertController(title: "알림", withMessage: "탑승자가 호출을 취소했습니다")
            print("asdasdas")
        }
    }
    
    func dobserveCurrentTrip() {
        PassengrService.shared.observCurrentTrip { trip in
            self.trip = trip
            guard let state = trip.state else {return}
            guard let driverUid = trip.driverUid else {return}
            
            switch state {
            case .requested:
                break
          
        
            case .accepted:
                self.shouldPresentLoading(false)
                self.removeAnnotationsAndOverlay()
                self.zoomForActiveTrip(withDriverUid: driverUid)
                Service.shared.fetchData(uid: driverUid) { user in
                    self.presentRideAcitonView(shouldShow: true, config: .tripAccepted, user: user)
                }
                
                
                
            case .driverArrived:
                self.rideActionView.config = .driverArrived
                
                
                
            case .inProgress:
                self.rideActionView.config = .tripInProgress
                
                
            case .arrivedAtDestination:
                self.rideActionView.config = .endTrip
                
                
            case .completed:
                PassengrService.shared.deletTrip { error, ref in
                    self.presentRideAcitonView(shouldShow: false)
                    self.centerMapOnuserLocation()
                    self.configureActionButtonSet(config: .showMenu)
                    self.presentAlertController(title: "운행 종료", withMessage: "운행이 종료되었습니다")
                    self.inputActivationView.alpha = 1
                }
            }
        }
    }
    
    func startTrip() {
        guard let trip = self.trip else {return}
        DriverService.shared.updateTripState(trip: trip, state: .inProgress) { error, ref in
            self.rideActionView.config = .tripInProgress
            self.removeAnnotationsAndOverlay()
            self.mapView.addAnnotationAndSelect(coordinate: trip.destinationCoordinates)
            
            let placemark = MKPlacemark(coordinate: trip.destinationCoordinates)
            let mapitem = MKMapItem(placemark: placemark)
            
            self.setCustomRegion(withType: .destination, withCoordinates: trip.destinationCoordinates)
            self.generatePolyLine(toDestination: mapitem)
            
            self.mapView.zoomToFit(annotaitions: self.mapView.annotations)
            
        }
    }
    
    //MARK: - 도움 메서드

    func makeLayout() {
        view.addSubview(mapView)
        configureRideActionView()
        
        mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        view.addSubview(actionButton)
        actionButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, paddingTop: 16, paddingLeading: 20,width: 30,height: 30)

    }
    
    func configureLocationInputActivationView() {
        view.addSubview(inputActivationView)
        inputActivationView.centerX(inView: view)
        inputActivationView.setDimensions(height: 50, width: view.frame.width - 64)
        inputActivationView.anchor(top: actionButton.bottomAnchor, paddingTop: 32)
        inputActivationView.alpha = 0
        inputActivationView.delegate = self

        
        UIView.animate(withDuration: 0.5) {
            self.inputActivationView.alpha = 1
        }
    }
    
    func configureLocationInputView() {
        view.addSubview(loccationInputView)
        loccationInputView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailng: view.trailingAnchor, height: 200)
        loccationInputView.alpha = 0
        UIView.animate(withDuration: 0) {
            self.loccationInputView.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.5) {
                self.tableview.frame.origin.y = self.locationInputViewheight
            }
        }

    }
    
    func configureTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        
        
        tableview.register(LocationCell.self, forCellReuseIdentifier: LocationCell.indentifier)
        tableview.rowHeight = 60
        tableview.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height - locationInputViewheight)
        tableview.tableFooterView = UIView()
        view.addSubview(tableview)
        
    }
    
    func dismissLocationView(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, animations: {
            self.loccationInputView.alpha = 0
            self.loccationInputView.removeFromSuperview()
            self.tableview.frame.origin.y = self.view.frame.height
        }, completion: completion)
    }
    
    func configureRideActionView() {
        view.addSubview(rideActionView)
        rideActionView.delegate = self
        rideActionView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 300)
    }
    
    func presentRideAcitonView(shouldShow: Bool,destination: MKPlacemark? = nil, config: RideActionViewConfiuration? = nil, user: User? = nil) {
       
        let yOrigin = shouldShow ? self.view.frame.height - 300 : self.view.frame.height
        
        
            UIView.animate(withDuration: 0.5) { [self] in
                rideActionView.frame.origin.y = yOrigin
        }
        
        if shouldShow {
            guard let config = config else {return}

            
            if let destination = destination {
                rideActionView.destination = destination
            }
            
            if let user = user {
                rideActionView.user = user
            }

            rideActionView.config = config
            
        }
    }
    
    
    
   private func configureActionButtonSet(config: ActionButtonConfiuration) {
        switch config {
        case.showMenu:
            self.actionButton.setImage(UIImage(named: "baseline_menu_black_36dp")?.withRenderingMode(.alwaysOriginal), for: .normal)
            self.actionButtonConfig = .showMenu
        case.dismissActionView:
            actionButton.setImage(UIImage(named: "backbutton2")?.withRenderingMode(.alwaysOriginal), for: .normal)
            actionButtonConfig = .dismissActionView
        }
    }
    
   
    
}



//MARK: - 위치 서비스

extension HomeController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        if region.identifier == AnnotationType.pickup.rawValue {
            print("디버그\(region)")
        }
        
        if region.identifier == AnnotationType.destination.rawValue {
            print("디버그\(region)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard let trip = self.trip else {return}
        
        if region.identifier == AnnotationType.pickup.rawValue {
            DriverService.shared.updateTripState(trip: trip, state: .driverArrived) { err, ref in
                self.rideActionView.config = .pickupPassenger
            }
        }
        
        if region.identifier == AnnotationType.destination.rawValue {
            DriverService.shared.updateTripState(trip: trip, state: .arrivedAtDestination) { err, ref in
                self.rideActionView.config = .endTrip
            }
        }
        

    }
    
    func enableLocationServices() {
        locationManager?.delegate = self
        
        switch locationManager?.authorizationStatus {
        case .notDetermined:
            print("결정되지않음")
            locationManager?.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways:
            print("항상 유지")
            locationManager?.startUpdatingLocation()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            print("자동으로 유지")
            locationManager?.requestAlwaysAuthorization()
            locationManager?.startUpdatingLocation()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        case .none:
            break
        @unknown default:
            break
        }
    }


    
}

//MARK: - 로케이션 액티비션 뷰 델리게이트
extension HomeController: LocationInputActivationViewDelegate {
    func presentLocationInputView() {
        inputActivationView.alpha = 0
        configureLocationInputView()
    }
    
    
}


//MARK: - 로케이션 인풋 뷰 델리게이트
extension HomeController: LocationInputViewDelegate {
    func executeSearch(query: String) {
        searchBy(naturalLanguageQuery: query) { result in
            self.searchResults = result
            self.tableview.reloadData()
            
        }
    }
    
    func dismissLocationInputView() {
        dismissLocationView { _ in
            UIView.animate(withDuration: 0.5) {
                self.inputActivationView.alpha = 1
            }
        }
    }
    
    
}

//MARK: - 맵뷰 델리게이트
extension HomeController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotaion = annotation as? DriverAnnotation {
            let view = MKAnnotationView(annotation: annotaion, reuseIdentifier: DriverAnnotation.annotationIdentified)
            view.image = UIImage().resizeImage(image: UIImage(named: "car")!, height: 30, width: 30)
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let route = self.reute {
            let polyline = route.polyline
            let lineRenderer = MKPolylineRenderer(overlay: polyline)
            lineRenderer.strokeColor = .systemBlue
            lineRenderer.lineWidth = 3
            return lineRenderer
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let user = self.user else {return}
        guard user.accountType == .driver else {return}
        guard let userLocation = userLocation.location else {return}
        DriverService.shared.updateDriverLocation(location: userLocation)
    }
    
    
}

//MARK: - 맵뷰 도움 매서드

private extension HomeController {
    func searchBy(naturalLanguageQuery: String, complition: @escaping([MKPlacemark]) -> Void) {
        var results = [MKPlacemark]()
        
        let request = MKLocalSearch.Request()
        request.region = mapView.region
        request.naturalLanguageQuery = naturalLanguageQuery
        
        let search = MKLocalSearch(request: request)
        search.start { respones, error in
            guard let respons = respones else {return}
            respons.mapItems.forEach({ item in
                results.append(item.placemark)
            })
            complition(results)
        }
    }
    
    func generatePolyLine(toDestination destination: MKMapItem) {
        
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = destination
        request.transportType = .automobile
        
        let directionRequest = MKDirections(request: request)
        directionRequest.calculate { respones, error in
            guard let respones = respones else {return}
            self.reute = respones.routes[0]
            guard let polyLine = self.reute?.polyline else {return}
            self.mapView.addOverlay(polyLine)
        }
        
    }
    
    func removeAnnotationsAndOverlay() {
        
        mapView.annotations.forEach { annotation in
            if let anno = annotation as? MKPointAnnotation {
                mapView.removeAnnotation(anno)
            }
        }
        
        if mapView.overlays.count > 0 {
            mapView.removeOverlay(mapView.overlays[0])
        }
    }
    
    func centerMapOnuserLocation() {
        guard let coordnate = locationManager?.location?.coordinate else {return}
        let region = MKCoordinateRegion(center: coordnate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(region, animated: true)
    }
    
    func setCustomRegion(withType type: AnnotationType ,withCoordinates coordinates: CLLocationCoordinate2D) {
        let region = CLCircularRegion(center: coordinates, radius: 25, identifier: type.rawValue)
        locationManager?.startMonitoring(for: region)
        
    }
    
    func zoomForActiveTrip(withDriverUid uid: String) {
        var annotations = [MKAnnotation]()
        self.mapView.annotations.forEach { annotation in
            if let anno = annotation as? DriverAnnotation {
                if anno.uid == uid {
                    annotations.append(anno)
                }
            }
            if let useranno = annotation as? MKUserLocation {
                annotations.append(useranno)
            }
        }
        self.mapView.zoomToFit(annotaitions: annotations)
    }
    
    
    
    
}


//MARK: - 테이블뷰 데이터소스
extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.indentifier, for: indexPath) as! LocationCell
            cell.placmark = searchResults[indexPath.row]
        

        return cell
    }
    
//MARK: - 테이블뷰 델리게이트
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlacemark = searchResults[indexPath.row]
        let destination = MKMapItem(placemark: selectedPlacemark)

        configureActionButtonSet(config: .dismissActionView)
        
        generatePolyLine(toDestination: destination)

        dismissLocationView { [self] _ in
            mapView.addAnnotationAndSelect(coordinate: selectedPlacemark.coordinate)
            //포인트를 지정했을때 거리에 따라서 확대되는걸 조정하는 코드
            let annotations = self.mapView.annotations.filter { annotation in
                !annotation.isKind(of: DriverAnnotation.self)
            }
            self.mapView.zoomToFit(annotaitions: annotations)
            
            presentRideAcitonView(shouldShow: true,destination: selectedPlacemark,config: .requestRide)
            
        }
    }
}

//MARK: - 라이더 액션뷰 델리게이터

extension HomeController: RideActionViewDelegate {

    
    func cancelTrip() {
        PassengrService.shared.deletTrip { error, ref in
            if error != nil {
                print("여행 삭제 실패")
                return
            }
            self.centerMapOnuserLocation()
            self.presentRideAcitonView(shouldShow: false)
            self.removeAnnotationsAndOverlay()
            self.actionButton.setImage(UIImage(named: "baseline_menu_black_36dp")?.withRenderingMode(.alwaysOriginal), for: .normal)
            self.actionButtonConfig = .showMenu
            self.inputActivationView.alpha = 1
        }
    }
    
    func uploadTrip(_ view: RideActionView) {
        guard let pickupCoordinates = locationManager?.location?.coordinate else {return}
        guard let destinationCoordinates = view.destination?.coordinate else {return}
        
        shouldPresentLoading(true, message: "드라이버를 찾고 있습니다...")
        
        PassengrService.shared.uploadTrip(pickupCoordinates: pickupCoordinates, destinationCoodinates: destinationCoordinates) { error, ref in
            if error != nil {
                print("여행 업로드 실패")
                return
            }
            
            UIView.animate(withDuration: 0.5) {
                self.rideActionView.frame.origin.y = self.view.frame.height
            }
        }
    }
    
    func pickupPassenger() {
        startTrip()
    }
    
    func dropOffPassenger() {
        guard let trip = self.trip else {return}
        DriverService.shared.updateTripState(trip: trip, state: .completed) { error, ref in
            self.removeAnnotationsAndOverlay()
            self.centerMapOnuserLocation()
            self.presentRideAcitonView(shouldShow: false)
        }
    }
}

//MARK: - 픽업뷰 델리게이터

extension HomeController: PickupControllerDelegate {
    func didAcceptTrip(_ trip: Trip) {
        self.trip = trip
        
        self.mapView.addAnnotationAndSelect(coordinate: trip.pickupCoordinates)
        
        setCustomRegion(withType: .pickup, withCoordinates: trip.pickupCoordinates)
        
        let placemark = MKPlacemark(coordinate: trip.pickupCoordinates)
        let mapitem = MKMapItem(placemark: placemark)
        generatePolyLine(toDestination: mapitem)
        
        mapView.zoomToFit(annotaitions: mapView.annotations)
        
      observeCanceldTrip(trip: trip)
        
        self.dismiss(animated: true) {
            Service.shared.fetchData(uid: trip.passengerUid) { user in
                self.presentRideAcitonView(shouldShow: true, config: .tripAccepted, user: user)
            }
        }
    }
    
    
    
    
    
}

