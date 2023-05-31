//
//  File.swift
//  Project-Clone-Uber
//
//  Created by 정덕호 on 2022/03/23.
//

import UIKit
import MapKit

protocol PickupControllerDelegate: AnyObject {
    func didAcceptTrip(_ trip: Trip)
}

class PickupController: UIViewController {
    
    //MARK: - 속성
    weak var delegate: PickupControllerDelegate?
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.isScrollEnabled = false
        map.isZoomEnabled = false
        map.isPitchEnabled = false
        return map
    }()
    
    let trip: Trip
    
    private lazy var circularProgressView: CircularProgressVIew = {
        let frame = CGRect(x: 0, y: 0, width: 360, height: 360)
        let view = CircularProgressVIew(frame: frame)
        
        view.addSubview(mapView)
        mapView.setDimensions(height: 268, width: 268)
        mapView.layer.cornerRadius = 268 / 2
        mapView.centerX(inView: view)
        mapView.centerY(inView: view, constant: 32)
        return view
    }()
    
    private let cancelButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(named: "baseline_clear_white_36pt_2x")?.withRenderingMode(.alwaysOriginal), for: .normal)
        bt.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return bt
    }()
    
    private let pickupLabel: UILabel = {
        let lable = UILabel()
        lable.text = "픽업요청이 왔습니다 수락하시겠습니까?"
        lable.font = .systemFont(ofSize: 16)
        lable.textColor = .white
        lable.textAlignment = .center
        return lable
    }()
    
    private let acceptTripButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.backgroundColor = .white
        bt.setTitle("수락하기", for: .normal)
        bt.setTitleColor(.black, for: .normal)
        bt.addTarget(self, action: #selector(handleAcceptTrip), for: .touchUpInside)
        bt.titleLabel?.font = .boldSystemFont(ofSize: 20)
        bt.anchor(height: 50)
        return bt
    }()
    
    private lazy var stack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [pickupLabel, acceptTripButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        return stack
    }()
    
    
    
    //MARK: - 라이프사이클
    
    init(trip: Trip) {
        self.trip = trip
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        confiureMapView()
        self.perform(#selector(animateProgress), with: nil, afterDelay: 0.5)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - 도움 메서드
    
    func configureUI() {
        view.backgroundColor = .black
        
        
        view.addSubview(cancelButton)
        cancelButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,leading: view.leadingAnchor,paddingLeading: 16)
        
        view.addSubview(circularProgressView)
        circularProgressView.setDimensions(height: 360, width: 360)
        circularProgressView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        circularProgressView.centerX(inView: view)
        
        view.addSubview(stack)
        stack.centerX(inView: view)
        stack.anchor(top: mapView.bottomAnchor,leading: view.leadingAnchor,trailng: view.trailingAnchor, paddingTop: 30,paddingLeading: 30,paddingTrailing: 30)

    }
    
    func confiureMapView() {
        let region = MKCoordinateRegion(center: trip.pickupCoordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: false)
        
        mapView.addAnnotationAndSelect(coordinate: trip.pickupCoordinates)
    }
    
    //MARK: - 셀렉터
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleAcceptTrip() {
        DriverService.shared.acceptTrip(trip: trip) { error, result in
            if error != nil {
                print("픽업 수락 실패")
                return
            }
            
            self.delegate?.didAcceptTrip(self.trip)
            
        }
    }
    
    @objc func animateProgress() {
        circularProgressView.animatePulsatringLayer()
        circularProgressView.setProgressWithAnimation(duration: 15, value: 0) {
         
            
        }
    }
    
    //MARK: - API
    

}
