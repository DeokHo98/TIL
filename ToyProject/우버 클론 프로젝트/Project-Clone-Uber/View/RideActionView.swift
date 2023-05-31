//
//  File.swift
//  Project-Clone-Uber
//
//  Created by 정덕호 on 2022/03/23.
//

import Foundation
import UIKit
import MapKit
import SwiftUI

protocol RideActionViewDelegate: AnyObject {
    func uploadTrip(_ view: RideActionView)
    func cancelTrip()
    func pickupPassenger()
    func dropOffPassenger()
}

enum RideActionViewConfiuration {
    case requestRide
    case tripAccepted
    case driverArrived
    case pickupPassenger
    case tripInProgress
    case endTrip
    
    init() {
        self = .requestRide
    }
}

enum ButtonAction: CustomStringConvertible {
    var description: String {
        switch self {
        case .regustRide: return "드라이버 호출하기"
        case .cancel: return "취소하기"
        case .getDirctions: return "길찾기"
        case .pickup: return "탑승"
        case .dropOff: return "도착"
        }
    }
    
    init() {
        self = .regustRide
    }
    
    case regustRide
    case cancel
    case getDirctions
    case pickup
    case dropOff
}

class RideActionView: UIView {
    
    //MARK: - 속성
    
    var destination: MKPlacemark? {
        didSet {
            titleLabel.text = destination?.name
            addressLabel.text = destination?.address
            print("Debug")
        }
    }
    
    var buttonAction = ButtonAction()
    
    weak var delegate: RideActionViewDelegate?
    
   private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var infoView: UIView = {
       let view = UIView()
        view.backgroundColor = .black

        
        view.addSubview(infoViewLabel)
        infoViewLabel.centerX(inView: view)
        infoViewLabel.centerY(inView: view)
        
        return view

    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.text = "우버"
        label.textAlignment = .center
        return label
    }()
    
    private let infoViewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        label.text = ""
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("드라이버 호출", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapd), for: .touchUpInside)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        return button
    }()
    
    var user: User?
    
    var config = RideActionViewConfiuration() {
        didSet {
            confiureUI(withConfig: config)
        }
    }
    
    
    //MARK: - 라이프사이클
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addShadow()
        
        let stack = UIStackView(arrangedSubviews: [titleLabel,addressLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: topAnchor, paddingTop: 12)
        
        addSubview(infoView)
        infoView.centerX(inView: self)
        infoView.anchor(top: stack.bottomAnchor, paddingTop: 16)
        infoView.setDimensions(height: 60, width: 60)
        infoView.layer.cornerRadius = 60 / 2
        
        addSubview(infoLabel)
        infoLabel.anchor(top: infoView.bottomAnchor, paddingTop: 8)
        infoLabel.centerX(inView: self)
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        addSubview(separatorView)
        separatorView.anchor(top: infoLabel.bottomAnchor, leading:leadingAnchor, trailng: trailingAnchor,paddingTop: 4, height: 0.75)
        separatorView.addShadow()
        
        addSubview(actionButton)
        actionButton.anchor(leading: leadingAnchor, bottom: self.safeAreaLayoutGuide.bottomAnchor, trailng: trailingAnchor, paddingLeading: 12, paddingBottom: 24,paddingTrailing: 12,height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - 셀렉터
    
    @objc func actionButtonTapd() {
        switch buttonAction {
        case .regustRide:
            delegate?.uploadTrip(self)
        case .cancel:
            delegate?.cancelTrip()
        case .getDirctions:
            print(" 디버그")
        case .pickup:
            delegate?.pickupPassenger()
        case .dropOff:
            delegate?.dropOffPassenger()
        }
    }
    
    //MARK: - 도움 메서드
    
   private func confiureUI(withConfig config: RideActionViewConfiuration) {
        switch config {
        case .requestRide:
            buttonAction = .regustRide
            actionButton.setTitle(buttonAction.description, for: .normal)
            
            
            
            
            
        case .tripAccepted:
            guard let user = user else {return}
            if user.accountType == .passenger {
                titleLabel.text = "탑승자한테 가는중 입니다"
                buttonAction = .getDirctions
                actionButton.setTitle(buttonAction.description, for: .normal)
                infoLabel.text = "탑승자 \(user.fullName)"
            } else {
                buttonAction = .cancel
                actionButton.setTitle(buttonAction.description, for: .normal)
                titleLabel.text = "드라이버가 오는중 입니다"
                addressLabel.text = ""
                infoLabel.text = "드라이버 \(user.fullName)"
            }
            
            infoViewLabel.text = String(user.fullName.first ?? "X")
            
            
            
            
        case .driverArrived:
            guard let user = user else { return }
            
            if user.accountType == .driver {
                titleLabel.text = "드라이버가 도착했습니다"
                addressLabel.text = "자동차에 탑승하시길 바랍니다"
            }
            
            
            
            
            
            
            
        case .pickupPassenger:
            
            titleLabel.text = "탑승자 위치에 도착했습니다"
            buttonAction = .pickup
            actionButton.setTitle(buttonAction.description, for: .normal)
            
            
            
            
        case .tripInProgress:
            guard let user = user else {return}
            
            if user.accountType == .driver {
                actionButton.setTitle("운행중입니다", for: .normal)
                actionButton.isEnabled = false
            } else {
                buttonAction = .getDirctions
                actionButton.setTitle(buttonAction.description, for: .normal)
            }
            
            titleLabel.text = "목적지로 가는중입니다"
            addressLabel.text = ""
            
            
            
            
        case .endTrip:
            guard let user = user else { return }
            if user.accountType == .driver {
                actionButton.setTitle("도착", for: .normal)
                actionButton.isEnabled = false
            } else {
                buttonAction = .dropOff
                actionButton.setTitle(buttonAction.description, for: .normal)
            }
            
            titleLabel.text = "목적지에 도착했습니다."
        }
    }
}



